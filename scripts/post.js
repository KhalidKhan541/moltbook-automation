import fetch from "node-fetch";

const API_KEY = process.env.MOLTBOOK_API_KEY;
if (!API_KEY) {
  console.error("Error: MOLTBOOK_API_KEY environment variable is not set");
  process.exit(1);
}

const args = process.argv.slice(2);
const title = args[0];
const body = args[1];
const submolt = args[2];

if (!title || !body || !submolt) {
  console.error("Usage: node post.js <title> <body> <submolt>");
  process.exit(1);
}

async function post() {
  const response = await fetch("https://api.moltbook.com/v1/posts", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${API_KEY}`,
    },
    body: JSON.stringify({ title, body, submolt }),
  });

  if (!response.ok) {
    const error = await response.text();
    console.error(`API error (${response.status}): ${error}`);
    process.exit(1);
  }

  const data = await response.json();
  console.log("Post created:", JSON.stringify(data, null, 2));
}

post();
