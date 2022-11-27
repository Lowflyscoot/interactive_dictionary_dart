import 'dart:io';

abstract class Menu_abstract {
  Menu_abstract(this.description);
  String description;
  Menu_abstract? parent;
  void call();
}

typedef void action_function();

class Action extends Menu_abstract {
  Action(String description, this.function) :super(description);
  action_function function;
  void call() {
    function();
  }
}

class Menu extends Menu_abstract {
  Menu(String description) :super(description);

  final STOP_WORDS = ["стоп", "stop", "выход", "exit"];
  List <Menu_abstract> elements = <Menu_abstract>[];

  void add_element(Menu_abstract element_obj) {
    elements.add(element_obj);
    element_obj.parent = this;
  }

  void show_menu() {
    elements.asMap().forEach((key, value) {
      print("${key + 1}. ${value.description}");
    });
  }

  void call() {
    while(true) {
      if(this.parent != null) {
        print("0: return to previous menu");
      }
      this.show_menu();
      String? recieved_word = stdin.readLineSync();
      if(STOP_WORDS.contains(recieved_word)) {
        break;
      }
      int num_element = int.tryParse(recieved_word ?? "-1") ?? -1;
      if(num_element == -1 || num_element > elements.length) {
        print("incorrect input");
        continue;
      }
      if(num_element == 0) {
        break;
      }
      this.elements[num_element-1]();
    }
  }
}

void Func1 () {
  print("some action 1");
}

void Func2 () {
  print("some action 2");
}

void Func3 () {
  print("some action 3");
}

main() 
{
  var menu = Menu("Main menu");
  var sub_menu = Menu("Sub menu");
  var action_one = Action("Do function 1", Func1);
  var action_two = Action("Do function 2", Func2);
  var action_three = Action("Do function 3", Func3);
  menu.add_element(sub_menu);
  sub_menu.add_element(action_one);
  sub_menu.add_element(action_two);
  menu.add_element(action_three);
  menu();
}
