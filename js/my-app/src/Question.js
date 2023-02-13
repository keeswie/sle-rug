  export class Question {
    constructor(ques, param, t, currentValue) {
      this.ques = ques;
      this.param = param;
      this.t = t;
      this.currentValue = currentValue
    }
  }

export class IfQuestion{
  constructor(exp, ifQuestions, elseQuestions){
    this.exp = exp
    this.ifQuestions = []
    this.elseQuestions = []
  }
  addQuestion(question, flag) {
    if(flag){
      this.ifQuestions.push(question);
    }else{
      this.elseQuestions.push(question);
    }
}
  
}