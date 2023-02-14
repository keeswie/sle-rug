import { Question, IfQuestion } from "./Question.js";
import { Form } from "./Form.js";
import { Expression } from "./Expression.js";
export function getForm() {
let form = new Form("taxOfficeExample");

let hasBoughtHouse = new Question("Did you buy a house in 2010?","hasBoughtHouse","boolean", true)
form.addQuestion(hasBoughtHouse, 0)
             

let hasMaintLoan = new Question("Did you enter a loan?","hasMaintLoan","boolean", true)
form.addQuestion(hasMaintLoan, 0)
             

let ex25 = new Expression("","", "ref", "hasSoldHouse");

let ifq10 = new IfQuestion(ex25)

let ex35 = new Expression("","", "ref", "valueResidue");

let sellingPrice = new Question("What was the selling price?","sellingPrice","expression",ex35)
ifq10.addQuestion(sellingPrice,1)
          

let privateDebt = new Question("Private debts for the sold house:","privateDebt","integer", 1)
ifq10.addQuestion(privateDebt, 1)
             

let ex5632 = new Expression("","", "ref", "sellingPrice");
let ex11256 = new Expression("","", "ref", "privateDebt");
let ex563 = new Expression(ex5632,ex11256,"subtract");
let ex562 = new Expression(ex563,"", "brackets");
let ex1116 = new Expression("","", "integer", 2);
let ex56 = new Expression(ex562,ex1116,"mult");
let ex55 = new Expression(ex56,"", "brackets");

let valueResidue = new Question("Value residue:","valueResidue","expression",ex55)
ifq10.addQuestion(valueResidue,1)
          

form.addQuestion(ifq10,0)
             

let ex332 = new Expression("","", "ref", "privateDebt");
let ex656 = new Expression("","", "integer", 0);
let ex33 = new Expression(ex332,ex656,"greater");

let ifq12 = new IfQuestion(ex33)

let hasSoldHouse = new Question("Did you sell a house in 2010?","hasSoldHouse","boolean", true)
ifq12.addQuestion(hasSoldHouse, 1)
             

form.addQuestion(ifq12,0)
             

return form;
}  
         