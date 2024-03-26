#include <iostream>
#include <stack>
#include <string>
#ifdef __EMSCRIPTEN__ 
    #include <emscripten/bind.h>
    using namespace emscripten;
#endif

bool isOperator(char c) {
    return (c == '+' || c == '-' || c == '*' || c == '/');
}

int performOperation(char operation, int operand1, int operand2) {
    switch (operation) {
        case '+':
            return operand1 + operand2;
        case '-':
            return operand1 - operand2;
        case '*':
            return operand1 * operand2;
        case '/':
            return operand1 / operand2;
        default:
            return 0;
    }
}

int evaluateExpression(const std::string& expression) {
    std::stack<int> operandStack;
    std::stack<char> operatorStack;
    
    int i = 0;

    for (char c : expression) {
        if (c == 0x20 || c == 0x9 || c == 0xD) {
            continue;
        } else if (isdigit(c)) {
            int operand = 0;
            while (isdigit(c)) {
                operand = operand * 10 + (c - '0');
                c = expression[++i];
            }
            operandStack.push(operand);
        } else if (isOperator(c)) {
            while (!operatorStack.empty() && isOperator(operatorStack.top())) {
                int operand2 = operandStack.top();
                operandStack.pop();
                int operand1 = operandStack.top();
                operandStack.pop();
                char op = operatorStack.top();
                operatorStack.pop();
                int result = performOperation(op, operand1, operand2);
                operandStack.push(result);
            }
            operatorStack.push(c);
        }
    }

    while (!operatorStack.empty()) {
        int operand2 = operandStack.top();
        operandStack.pop();
        int operand1 = operandStack.top();
        operandStack.pop();
        char op = operatorStack.top();
        operatorStack.pop();
        int result = performOperation(op, operand1, operand2);
        operandStack.push(result);
    }

    return operandStack.top();
}

#ifndef __EMSCRIPTEN__ 
int main() {
    std::string expression = "5 + 4";
    std::cout << "Enter an expression: ";
    // std::getline(std::cin, expression);

    int result = evaluateExpression(expression);
    std::cout << "Result: " << result << std::endl;

    return 0;
}
#endif

#ifdef __EMSCRIPTEN__ 
    EMSCRIPTEN_BINDINGS(my_module) {
        function("evaluateExpression", &evaluateExpression);
    }
#endif

/*

// assign : ID '=' expr ';';
void assign() {
    match(ID);     // 根据assign规则生成的方法
    match('=');    // 将当前的输入符号和ID相比较，然后将其消费掉
    expr();        
    match(';');    // 通过调用方法expr()来匹配一个表达式
}

void stat() {
    switch (token) {
        case ID:
            assign();
            break;
        case IF:
            ifstat();
            break;
        case WHILE:
            whilestat();
            break;
        default:
            throw;
    }
}
*/
