import React from "react";
import ReactDOM from "react-dom/client";
import { Question } from "./Question";

export class JQuestion extends React.Component {
  constructor(props) {
    super(props);

    this.handleChange = this.handleChange.bind(this);

    this.state = {
      ques: props.question.ques,
      param: props.question.param,
      t: props.question.t,
      currentValue: props.question.currentValue,
    };
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
