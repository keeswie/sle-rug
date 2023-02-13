import React from "react";
import ReactDOM from "react-dom/client";
import { JForm } from "./JForm.js";
import JQuestion from "./JQuestion.js";
export function display(form){
const root = ReactDOM.createRoot(document.getElementById("root"));


root.render(<JForm/>);
}