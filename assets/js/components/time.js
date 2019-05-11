import relativeDate from 'tiny-relative-date';
import { component } from "haunted";
import { html } from "lit-html";

function Time({datetime}) {
  return html`
    <time datetime=${datetime}>
      ${relativeDate(datetime)}
    </time>
  `;
}

Time.observedAttributes = ["datetime"];

customElements.define(
  "relative-time",
  component(Time, HTMLElement, { useShadowDOM: true})
);
