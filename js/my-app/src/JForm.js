import React from "react";
import ReactDOM from "react-dom/client";
import { JQuestion }from "./JQuestion";
import { Question } from "./Question";
export class JForm extends React.Component {
  constructor(props) {
    super(props);
    this.handleQuestionChange = this.handleQuestionChange.bind(this);
    this.state = { id: props.id, questions: props.questions };
    
    //   this.handleChange = this.handleChange.bind(this);
    //   this.handleSubmit = this.handleSubmit.bind(this);
    
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
  // handleChange(event) {    this.setState({value: event.target.value});  }
  // handleSubmit(event) {
  //   alert('A name was submitted: ' + this.state.value);
  //   event.preventDefault();
  // }
 
  render() {
    console.log(this.state);
    let i=0
    return (
      <div>
        <h1>{this.state.id}</h1>
        <ul>
        {this.state.questions.map((q) =>{return <JQuestion question={q}  onQuestionChange={this.handleQuestionChange}/>} )}
      </ul>
      </div>
    );
  }
}
