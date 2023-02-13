import React from "react";
import ReactDOM from "react-dom/client";
import { JForm } from "./JForm";
import { getForm } from "./tax.js";

const root = ReactDOM.createRoot(document.getElementById("root"));
let form = getForm();

root.render(<JForm id={form.id} questions={form.questions} />);
