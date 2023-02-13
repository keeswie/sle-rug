import React from "react";
import ReactDOM from "react-dom/client";
export class JForm extends React.Component {
    constructor(props) {
      super(props);
      this.state = {id: props.id,
                    questions: props.questions};
    //   this.handleChange = this.handleChange.bind(this);
    //   this.handleSubmit = this.handleSubmit.bind(this);
    }
  
    // handleChange(event) {    this.setState({value: event.target.value});  }
    // handleSubmit(event) {
    //   alert('A name was submitted: ' + this.state.value);
    //   event.preventDefault();
    // }
  
    render() {
        return (
            <div>
              hooi
            </div>
          );
    }
  }