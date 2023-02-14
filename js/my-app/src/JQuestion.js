import React from "react";
import ReactDOM from "react-dom/client";
import { Question } from "./Question";

export class JQuestion extends React.Component {
  constructor(props) {
    super(props);
    this.handleChange = this.handleChange.bind(this);
    this.findValue = this.findValue.bind(this);
    
    this.state = {
      ques: props.question.ques,
      param: props.question.param,
      t: props.question.t,
      currentValue: props.question.currentValue,
    };
  }

calculateExpr(expr){
  if(typeof expr.op !== 'undefined'){
    switch (expr.op) {
      case "ref": {return this.findValue(expr.value)} ;
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
    }else{
     return expr
    }
  }
  findValue(param){
    return this.props.onAskValue(param)
  }
  handleChange(e) {
    if (this.state.t === "boolean") {
      this.setState({ currentValue: !this.state.currentValue });
      this.props.onQuestionChange(this.state.param, !this.state.currentValue);
    } else if(this.state.t === "string"){
      this.setState({ currentValue: e.target.value });
      this.props.onQuestionChange(this.state.param, e.target.value);
    }else{
      this.setState({ currentValue: e.target.value });
      this.props.onQuestionChange(this.state.param, parseInt(e.target.value));
    }

    this.forceUpdate();
  }
  renderSwitch(question) {
    switch (question.t) {
      case "integer":
        return (
          <div>
            <input
              name={question.param}
              type="number"
              value={this.calculateExpr(this.state.currentValue)}
              onChange={this.handleChange}
            />
          </div>
        );

      case "boolean":
        return (
          <div>
            <input
              name={question.param}
              type="checkbox"
              checked={this.calculateExpr(this.state.currentValue)}
              onChange={this.handleChange}
            />
          </div>
        );

      case "string":
        return (
          <div>
            <textarea
              value={this.calculateExpr(this.state.currentValue)}
              onChange={this.handleChange}
            ></textarea>
          </div>
        );
        case "expression":
              if(typeof this.calculateExpr(this.state.currentValue)==="boolean"){
                return<div>True</div>
              }else{
                return<div>{this.calculateExpr(this.state.currentValue)}</div>
              }
    }
  }

  render() {
    
      return (
        <div>
          <h3>{this.state.ques}</h3>
          {this.renderSwitch(this.state)}
        </div>
      );
  
  }
}
