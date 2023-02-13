import { Question, IfQuestion } from "./Question.js";
import { Form } from "./Form.js";
import { Expression } from "./Expression.js";
let form = new Form("hoi");
let q1 = new Question("?", "q1", "integer", 4)
let q2 = new Question("dasdsa?", "q2", "integer", 5)
form.addQuestion(q1);
form.addQuestion(q2);

let ex1 = new Expression("","","ref","q1")
let ex2 = new Expression("","","ref","q2")
let ex3 = new Expression(ex1,ex2,"add")

let q3 = new IfQuestion(ex3, q1, q2)
form.addQuestion(q3);
console.log(form);

console.log(ex3.getValue(ex3, form))