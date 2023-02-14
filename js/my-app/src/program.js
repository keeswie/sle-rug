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
             

let ex33 = new Expression("","", "ref", "hasSoldHouse");

let ifq12 = new IfQuestion(ex33)

let sellingPrice = new Question("What was the selling price?","sellingPrice","integer", 1)
ifq12.addQuestion(sellingPrice, 1)
             

let privateDebt = new Question("Private debts for the sold house:","privateDebt","integer", 1)
ifq12.addQuestion(privateDebt, 1)
             

let ex632 = new Expression("","", "ref", "sellingPrice");
let ex12572 = new Expression("","", "ref", "privateDebt");
let ex25136 = new Expression("","", "integer", 5);
let ex1257 = new Expression(ex12572,ex25136,"add");
let ex1256 = new Expression(ex1257,"", "brackets");
let ex63 = new Expression(ex632,ex1256,"subtract");

let valueResidue = new Question("Value residue:","valueResidue","expression",ex63)
ifq12.addQuestion(valueResidue,1)
          

form.addQuestion(ifq12,0)
             

return form;
}  
         