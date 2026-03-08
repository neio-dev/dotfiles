class Candidate {
    constructor(name) {
        this.name = name;
    }
    interestLevel = 0;
    name: string;
    currentQuestion: number;
    dialogue: Question[];
}

class Question {
    label: string;
}

class FreeTextQuestion extends Question {
    callback: Function;
} // champ libre pas de Answer predefini

class ChoiceQuestion extends Question {
    allowMulti: boolean;
    answers: Answer[];
} // utilise Answer

class Answer {
    label: string;
    isPositive: boolean;
}

class Pod {
    states: string[];
    currentState: string;
    changeState: (newState: string) => void;
}

class MessagesManager {
    element: HTMLElement;
    currentMessage: string;
    changeMessage: (newMessage: string) => string;
}

class InputsManager {
    element: HTMLElement;
    inputs: (Button | Input)[];
    changeInputs: (inputs: (Button | Input)[]) => void;
    parseQuestion: (question: Question, onAnswer: (isPositive: boolean) => void) => {}
}

class Button {
    label: string;
    onClick: Function;
    createElement: () => HTMLElement;
}

class Input {
    onEnter: Function;
    createElement: () => HTMLElement;
}


const pod = new Pod();
const messageManager = new MessagesManager();
const inputsManager = new InputsManager();

class Game {
    candidates: { [name: string]: Candidate } = {
        dylan: new Candidate("Dylan"),
        herve: new Candidate("Herve"),
    };

    currentCandidate: Candidate;

    startGame() {
        this.findNextCandidate()
        pod.changeState("presence")
        messageManager.changeMessage(this.currentCandidate.name + " a rejoint le pod.")

        this.startTalkingPhase();
    };

    findNextCandidate() {
        pod.changeState("joining")
        messageManager.changeMessage("En recherche de candidat...")

        this.currentCandidate = this.candidates.dylan;
        pod.changeState("presence")
    }

    startTalkingPhase() {
        const currentQuestion = this.currentCandidate.dialogue[this.currentCandidate.currentQuestion];
        this.askQuestion(currentQuestion).then((isPositive) => {
            pod.changeState(isPositive ? "thinking-right" : "thinking-wrong")
            this.currentCandidate.interestLevel += isPositive ? 10 : -10;
        });

        if (this.currentCandidate.currentQuestion < this.currentCandidate.dialogue.length - 1) {
            this.currentCandidate.currentQuestion += 1;
            this.startTalkingPhase();
        }
    }

    askQuestion(question: Question): Promise<boolean> {
        pod.changeState("talking");
        messageManager.changeMessage(question.label);

        pod.changeState("presence");
        return new Promise((resolve, reject) => {
            inputsManager.parseQuestion(question, (isPositive) => {
                resolve(isPositive);
            });
        })
    }
}


