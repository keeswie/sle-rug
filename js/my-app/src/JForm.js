import React from "react";
import ReactDOM from "react-dom/client";
import { JQuestion }from "./JQuestion";
import { Question } from "./Question";
export class JForm extends React.Component {
  constructor(props) {
    super(props);
    this.handleQuestionChange = this.handleQuestionChange.bind(this);
    this.handleAskValue = this.handleAskValue.bind(this);
    this.state = { id: props.id, questions: props.questions };
  }
  handleQuestionChange(question, value) {
    const nextShapes = this.state.questions.map(q => {
      if (q.param === question) {
        return new Question(q.ques, q.param, q.t, value)        
      } else {
        return q;
      }
    });
    this.setState({
    questions: nextShapes,
    })
     
  }
  handleAskValue(param){
    let answer;
    this.state.questions.map(q => {
      if (q.param === param) {
        if(q.currentValue){
          console.log("q.currentValue")
          answer = 1
        }       
      }})
    return answer
  }
 
  render() {
    console.log(this.state);
    return (
      <div>
        <h1>{this.state.id}</h1>
        <ul>
        {this.state.questions.map((q) =>{return <JQuestion question={q}  onQuestionChange={this.handleQuestionChange} onAskValue={this.handleAskValue}/>} )}
      </ul>
      </div>
    );
  }
}
