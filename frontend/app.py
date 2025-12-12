import streamlit as st
import requests
import os
from dotenv import load_dotenv

load_dotenv()


APIURL = f"https://eriks-aichatbot.azurewebsites.net/chatbot/query?code={os.getenv('FUNCTION_APP_API')}"

st.set_page_config(page_title="AIengineering Chatbot", page_icon="💻")
st.title("AIengineering Chatbot 💡")

# Saves chat history
if "messages" not in st.session_state:
    st.session_state.messages = [] 

# Shows history
for msg in st.session_state.messages:
    with st.chat_message(msg["role"]):
        st.markdown(msg["content"])

# Chatwindow
if prompt := st.chat_input("Ask anything related to Data engineering"):
    # add message
    st.session_state.messages.append({"role": "user", "content": prompt})
    with st.chat_message("user"):
        st.markdown(prompt)

    # Make api call
        resp = requests.post(APIURL, json={"prompt": prompt})
        resp.raise_for_status()
        data = resp.json()  

        answer = data.get("answer")
        filename = data.get("filename")
       
        # Bot answer
        if filename:
            bot_text = f"{answer}\n\n_**Source📖**: {filename}_"

    # Add the bots answer to history
    st.session_state.messages.append({"role": "assistant", "content": bot_text})
    with st.chat_message("assistant"):
        st.markdown(bot_text)

# Deleting chat
if st.button("Rensa chatt"):
    st.session_state.messages = []
    st.rerun()

