import {AxiosError} from "axios";
import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import {Configuration, OpenAIApi} from "openai";
import * as path from "path";
import * as os from "os";
import * as fs from "fs";
import axios from "axios";

admin.initializeApp();

const storage = admin.storage();
const configuration = new Configuration({
  organization: process.env.ORGANIZATION,
  apiKey: process.env.OPENAI_API_KEY,
});

const openai = new OpenAIApi(configuration);
const myKey = process.env.OPENAI_API_KEY;
const myWhisperEndpoint = "https://api.openai.com/v1/audio/transcriptions";

export const onVoiceFileGotUploaded = functions.storage
  .object()
  .onFinalize(async (object) => {
    const filePath = object.name ?? "";
    const bucketName = object.bucket ?? "";

    const fileExtension = path.extname(filePath);
    if (![".mp3", ".wav", ".ogg"].includes(fileExtension)) {
      console.log(
        `${filePath} I saw the uploaded file but seems like is
        not in the target extensions list (:`
      );
      return null;
    }

    const tempFilePath = path.join(os.tmpdir(),
      path.basename(filePath));
    await storage.bucket(bucketName).file(filePath)
      .download({destination: tempFilePath});

    try {
      const myFile = fs.createReadStream(tempFilePath);
      const requestData = {
        model: "whisper-1",
        file: myFile,
      };
      const headers = {
        "Authorization": `Bearer ${myKey}`,
        "Content-Type": "multipart/form-data",
      };

      const response = await axios
        .post(myWhisperEndpoint, requestData, {headers});
      console.log("Whisper Response:", response.data);

      await admin.firestore().collection("messages").add({
        text: response.data.text,
        role: Role.USER,
        timestamp: new Date().toISOString(),
      });
    } catch (error) {
      console.error((error as AxiosError).response?.data);
    }

    fs.unlinkSync(tempFilePath);
    return null;
  });

export const replyFromChatGPT = functions.firestore
  .document("messages/{messageId}")
  .onCreate(async (snap) => {
    try {
      const {text, role} = snap.data() as ChatMessage;

      if (snap.data()?.role === Role.ASSISTANT) return;

      const history = await admin.firestore().collection("messages")
        .orderBy("timestamp").limitToLast(5).get();
      const historyMapped = history.docs.map((doc) => {
        const {text, role} = doc.data() as ChatMessage;
        return {
          content: text,
          role,
        };
      });

      const response = await openai.createChatCompletion({
        model: "gpt-3.5-turbo",
        messages: [...historyMapped, {content: text, role}],
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
  ASSISTANT = "assistant"
}
