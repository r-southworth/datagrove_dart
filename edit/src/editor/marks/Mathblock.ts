import { toggleMark } from "prosemirror-commands";
import markInputRule from "../lib/markInputRule";
import Mark from "./Mark";
import markRule from "../rules/mark";


export default class Mathblock extends Mark {
    get name() {
      return "math";
    }
  
    get schema() {
      return {
        parseDOM: [{ tag: "mark" }],
        toDOM: () => ["mark"],
      };
    }
  
    inputRules({ type }) {
      return [markInputRule(/(?:$$)([^$]+)(?:$$)$/, type)];
    }
  
    keys({ type }) {
      return {
        "Mod-Ctrl-k": toggleMark(type),
      };
    }
  
    get rulePlugins() {
      return [markRule({ delim: "==", mark: "mathblock" })];
    }
  
    get toMarkdown() {
      return {
        open: "$$",
        close: "$$",
        mixable: true,
        expelEnclosingWhitespace: true,
      };
    }
  
    parseMarkdown() {
      return { mark: "mathblock" };
    }
  }
  