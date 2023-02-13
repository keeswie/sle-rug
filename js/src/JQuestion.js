import { useState } from "react";
import ReactDOM from "react-dom/client";

export default function JQuestion(props) {
  const [question, setQues] = useState({
    question: props.question,
    param: props.ques,
    exp: props.exp,
    t: props.t
  });
  console.log(question)
  const updateValue = (change) => {
    setQues(previousState => {
      return { ...previousState, exp: change }
    });
  }

  // switch (question.t) {
  //       case "integer":
  //           return (<div><label>{question.question}
  //                   <input name= {question.param}type="number" value= {question.exp}/>
  //                   </label></div>)
           
    
  //       case "boolean":
  //           return (<div>
  //           <label>{question.question}
  //           <input name={question.param} type="checkbox" checked={question.exp}/>
  //           </label></div>)
             
           
        
  //       case "string":
  //           return (<div><label>{question.question}<textarea> {question.exp} </textarea></label></div>);
            
  // }
}

// switch (this.t) {
//     case "integer":
//         react += `<label>\n${this.ques}\n`+
//                     `<input \tname=${this.ques}\n \ttype="number"\n \tvalue=${this.exp}/>\n`+
//                 `</label>\n`
//         break;

//     case "boolean":
//         react +=`<label>\n${this.ques}\n` +
//         `<input \tname=${this.ques}\n \ttype="checkbox"\n \tchecked=${this.exp}/>\n`+
//         `</label>\n`
         
//         break;
    
//     case "string":
//         react += `<label>\n` + `${this.ques}\n` + `<textarea> ${this.exp} </textarea>\n</label>`;
//         break;
    