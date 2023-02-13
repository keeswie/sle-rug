import React from "react";
import ReactDOM from "react-dom/client";
import { Question } from "./Question";

export class JQuestion extends React.Component {
  constructor(props) {
    super(props);
    
    this.handleChange = this.handleChange.bind(this);
    this.findValue = this.findValue.bind(this);
    let temp
    if(props.question.t === "expression"){
      temp = this.calculateExpr(props.question.currentValue)
      console.log(temp)
    }else{
      temp = props.question.currentValue;
    }
    this.state = {
      ques: props.question.ques,
      param: props.question.param,
      t: props.question.t,
      currentValue: temp,
    };
  }

  calculateExpr(expr){
    console.log(expr.op)
    switch (expr.op) {
      case "ref": return this.findValue(expr.value);
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
  findValue(param){
    return this.props.onAskValue(param)
  }
  handleChange(e) {
    if (this.state.t === "boolean") {
      this.setState({ currentValue: !this.state.currentValue });
      this.props.onQuestionChange(this.state.param, !this.state.currentValue);
    } else {
      this.setState({ currentValue: e.target.value });
      this.props.onQuestionChange(this.state.param, e.target.value);
    }
  }
  renderSwitch(question) {
    switch (question.t) {
      case "integer":
        return (
          <div>
            <input
              name={question.param}
              type="number"
              value={this.state.currentValue}
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
              checked={this.state.currentValue}
              onChange={this.handleChange}
            />
          </div>
        );

      case "string":
        return (
          <div>
            <textarea
              value={this.state.currentValue}
              onChange={this.handleChange}
            ></textarea>
          </div>
        );
        case "expression":
          return (
            <div>
              {this.state.currentValue}
            </div>
          );
    }
  }

  renderIf(question) {
    return <h3>hoi</h3>;
  }
  render() {
    if (this.state.ques) {
      return (
        <div>
          <h3>{this.state.ques}</h3>
          {this.renderSwitch(this.state)}
        </div>
      );
    } else {
      return <div>{this.renderIf(this.state)}</div>;
    }
  }
}
