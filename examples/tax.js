import { Question, IfQuestion } from "./Question.js";
import { Form } from "./Form.js";
import { Expression } from "./Expression.js";
export function getForm() {
let form = new Form("taxOfficeExample");

let hasBoughtHouse = new Question("Did you buy a house in 2010?","hasBoughtHouse","boolean", true)
form.addQuestion(hasBoughtHouse, 0)
             

let hasMaintLoan = new Question("Did you enter a loan?","hasMaintLoan","boolean", true)
form.addQuestion(hasMaintLoan, 0)
             

let hasSoldHouse = new Question("Did you sell a house in 2010?","hasSoldHouse","boolean", true)
form.addQuestion(hasSoldHouse, 0)
             

let ex33 = new Expression("","", "ref", "hasMaintLoan");

let valueResidue = new Question("Value residue:","valueResidue","expression",ex33)
form.addQuestion(valueResidue,0)
          

return form;
}  
         