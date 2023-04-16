import { AxiosError } from "axios";
import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import { Configuration, OpenAIApi } from "openai";

admin.initializeApp();

const configuration = new Configuration({
	organization: process.env.ORGANIZATION,
	apiKey: process.env.OPENAI_API_KEY,
});

const openai = new OpenAIApi(configuration);

export const replyFromChatGPT = functions.firestore
	.document("messages/{messageId}")
	.onCreate(async (snap) => {
		try {
			const { text, role } = snap.data() as ChatMessage;

			if (snap.data()?.role === Role.ASSISTANT) return;

			const history = await admin
				.firestore()
				.collection("messages")
				.orderBy("timestamp")
				.limitToLast(5)
				.get();

			const historyMapped = history.docs.map((doc) => {
				const { text, role } = doc.data() as ChatMessage;

				return {
					content: text,
					role,
				};
			});

			const response = await openai.createChatCompletion({
				model: "gpt-4",
				messages: [...historyMapped, { content: text, role }],
			});

			console.log("Response: ", response.data.choices[0].message);

			await admin.firestore().collection("messages").add({
				text: response.data.choices[0].message?.content,
				role: response.data.choices[0].message?.role,
				timestamp: new Date().toISOString(),
			});
		} catch (error) {
			console.error((error as AxiosError).response?.data);
		}
	});

type ChatMessage = {
	text: string;
	role: Role;
	timestamp: number;
};

enum Role {
	USER = "user",
	ASSISTANT = "assistant",
}
