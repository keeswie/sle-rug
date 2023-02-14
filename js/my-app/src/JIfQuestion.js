import React from "react";
import ReactDOM from "react-dom/client";
import { Question } from "./Question";
import { JQuestion }from "./JQuestion";
export class JIfQuestion extends React.Component {
  constructor(props) {
    super(props);
    this.handleOwnAskValue = this.handleOwnAskValue.bind(this)
    this.handleOwnQuestionChange = this.handleOwnQuestionChange.bind(this)
        
    this.state = {
      count:0,
      expr: props.question.exp,
      ifQuestions: props.question.ifQuestions,
      elseQuestions: props.question.elseQuestions,
    };

  }



  handleOwnAskValue(param){
    let answer = null;
    if(typeof this.state !== 'undefined'){
      if(typeof this.state.ifQuestions !== 'undefined'){
        this.state.ifQuestions.map(q => {
          if (q.param === param) {
            if(q.currentValue){
              answer = q.currentValue
            }   
          }})
        }
        if(typeof this.state.elseQuestions !== 'undefined' && answer == null){
          this.state.elseQuestions.map(q => {
            if (q.param === param) {
              if(q.currentValue){
                answer = q.currentValue
              }   
            }})
        }
    }
    if(answer == null){
      answer = this.props.onAskValue(param)
    }
    
    return answer
  }

  handleOwnQuestionChange(question, value){
    
    const nextifQuest = this.state.ifQuestions.map(q => {
      if (q.param === question) {
        return new Question(q.ques, q.param, q.t, value)        
      } else {
        return q;
      }
    });
    this.setState({
    ifQuestions: nextifQuest,
    })
    const nextElseQuest = this.state.elseQuestions.map(q => {
      if (q.param === question) {
        
        return new Question(q.ques, q.param, q.t, value)        
      } else {
        return q;
      }
    });
    this.setState({
    elseQuestions: nextElseQuest,
    })
    
    this.props.onQuestionChange(question, value);
    this.forceUpdate();
  }


  renderIf(){
    
    
    if(this.calculateExpr(this.state.expr)){
        return (
          <ul>
          {this.state.ifQuestions.map((q) =>{if(q.ques){return <JQuestion question={q}  onQuestionChange={this.handleOwnQuestionChange} onAskValue={this.handleOwnAskValue}/>
          }else{
            return <JIfQuestion question={q}  onQuestionChange={this.handleOwnQuestionChange} onAskValue={this.handleOwnAskValue}/>
          }})}
      </ul>
        )
    }
  }
  
  calculateExpr(expr){
    
    switch (expr.op) {
      case "ref": return this.handleOwnAskValue(expr.value);
      case "integer": return expr.value;
      case "boolean": return expr.value;
      case "brackets": return this.calculateExpr(expr.left);
      case "not": return !(this.calculateExpr(expr.left));
      case "mult": return (this.calculateExpr(expr.left) * this.calculateExpr(expr.right));
      case "div": return (this.calculateExpr(expr.left) / this.calculateExpr(expr.right));
      case "add": return (this.calculateExpr(expr.left) + this.calculateExpr(expr.right));
      case "subtract": return (this.calculateExpr(expr.left) - this.calculateExpr(expr.right));
      case "greater": return (this.calculateExpr(expr.left) > this.calculateExpr(expr.right));
      case "less": return (this.calculateExpr(expr.left) < this.calculateExpr(expr.right));
      case "greq": return (this.calculateExpr(expr.left) >= this.calculateExpr(expr.right));
      case "leq": return (this.calculateExpr(expr.left) <= this.calculateExpr(expr.right));
      case "neq": return (this.calculateExpr(expr.left) != this.calculateExpr(expr.right));
      case "conj": return (this.calculateExpr(expr.left) && this.calculateExpr(expr.right));
      case "disj": return (this.calculateExpr(expr.left) || this.calculateExpr(expr.right));
    }
  }


  
  render() {
    
      return (
        <div>
          {this.renderIf()}
        </div>
      );
  
  }
}
