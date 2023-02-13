export class Form {
    constructor(id) {
      this.id = id;
      this.questions = [];
    }
    addQuestion(question, flag) {
        this.questions.push(question);
    }
  }

