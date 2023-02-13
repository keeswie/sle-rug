
export class Expression{
    constructor(left, right, op, value){
    this.left = left;
    this.right = right;
    this.op = op;
    this.value = value
    }

    getValue(expr, form ){
        switch (expr.op) {
            case "ref":  return form.questions.find(element => element.param === expr.value ).currentValue ;
            case "integer": return expr.value;
            case "boolean": return expr.value;
            case "brackets": return this.getValue(expr.left, form);
            case "not": return (!(this.getValue(expr.left, form)));
            case "mult": return this.getValue(expr.left, form) * this.getValue(expr.right, form);
            case "div": return this.getValue(expr.left, form) / this.getValue(expr.right, form);
            case "add": return this.getValue(expr.left, form) + this.getValue(expr.right, form);
            case "subtract": return this.getValue(expr.left, form) - this.getValue(expr.right, form);
            case "greater": return this.getValue(expr.left, form) > this.getValue(expr.right, form);
            case "less": return this.getValue(expr.left, form) < this.getValue(expr.right, form);
            case "greq": return this.getValue(expr.left, form) >= this.getValue(expr.right, form);
            case "leq": return this.getValue(expr.left, form) <= this.getValue(expr.right, form);
            case "neq": return this.getValue(expr.left, form) != this.getValue(expr.right, form);
            case "conj":return this.getValue(expr.left, form) && this.getValue(expr.right, form);;
            case "disj":return this.getValue(expr.left, form) || this.getValue(expr.right, form);   
            default: throw "Unsupported expression <e>";
          }   
    }
    
      
  }