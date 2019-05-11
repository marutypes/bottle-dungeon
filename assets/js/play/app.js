import { component, useMemo, useReducer, useEffect } from "haunted";
import { html } from "lit-html";

import "../components/time";
import { socket } from "../socket";

const sampleMessage = {
  id: 2,
  character: "Baldwin the Burgundy",
  type: "roll",
  value: "4",
  stat: "CON"
},

const App = ({ token, campaign }) => {
  const [state, dispatch] = useReducer((prevState, {type, data}) => {
    switch (type) {
      case "new_message":
        return {
          ...prevState,
          messages: [...prevState.messages, data]
        };
      case "update_textarea":
        return {
          ...prevState,
          textAreaValue: data,
        };
      default:
        return prevState;
    }
  }, {messages: [], textAreaValue: ''});

  const channel = useMemo(() => {
    socket.connect({token: token});

    const channel = socket.channel(`play:${campaign}`);
    channel.join()
      .receive("ok", resp => console.log("joined the channel", resp))
      .receive("error", reason => console.log("join failed", reason));

    return channel;
  }, [token, campaign]);

  useEffect(() => {
    channel.on("new_message", (data) => {
      dispatch({type: "new_message", data});
    });
  }, [channel]);

  return html`
    <div class="flex-grow flex flex-col">
      <div class="msg-pane flex-grow">
        ${state.messages.map(({body, at, user}) => html`
          <div>
            <p class="text-bold">${user.username}</b>
            <p><relative-time datetime=${at}></relative-time></p>
            <p>${body}</p>
          </div>
        `)}
      </div>

      <div class="flex flex-none">
        <textarea
          class="flex-grow"
          id="msg-input"
          rows="3"
          placeholder="Comment..."
          .value=${state.textAreaValue}
          @change=${(ev) => {
            dispatch({type: "update_textarea", data: ev.target.value})
          }}
        ></textarea>

        <button
          @click=${() => {
            channel.push(
              "new_message",
              {body: state.textAreaValue, at: new Date()}
            )
            dispatch({type: "update_textarea", data: ""})
          }}
          id="msg-submit"
          class="button button--primary"
          type="submit">
          Post
        </button>
      </div>
    </div>
  `;
};

App.observedAttributes = ["token", "campaign"];

customElements.define(
  "bottle-dungeon-app",
  component(App, HTMLElement, { useShadowDOM: false })
);
