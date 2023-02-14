import React from "react";
import ReactDOM from "react-dom/client";
import { JQuestion }from "./JQuestion";
import { Question } from "./Question";
import { JIfQuestion } from "./JIfQuestion";
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
          answer = q.currentValue
        }   
      }})

    return answer
  }
 
  render() {
    return (
      <div>
        <h1>{this.state.id}</h1>
        <ul>
        {this.state.questions.map((q) =>{if(q.ques){return <JQuestion question={q}  onQuestionChange={this.handleQuestionChange} onAskValue={this.handleAskValue}/>}else{
          return  <JIfQuestion question={q}  onQuestionChange={this.handleQuestionChange} onAskValue={this.handleAskValue}/>
        }})}
      </ul>
      </div>
    );
  }
}
