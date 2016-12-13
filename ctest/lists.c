#include <stdio.h>

typedef struct timer_data timer_data;
typedef struct list_element list_element;

struct timer_data {
    int index;
    unsigned long starttime;
    int settime;
};

struct list_element {
    timer_data* data;
    list_element* next;
};

int add_to_list(list_element* head, timer_data* toadd){
    list_element* current;
    list_element add;
    current = head;
    while (current->next != NULL) {
        current = current->next;
    }
    add.data = toadd;
    add.next = NULL;
    current->next = &add;
    return 1;
}

list_element* remove_from_list(list_element* head, timer_data* toremove){
    list_element* current;
    list_element* last;
    last = head;
    current = head->next;
    while (current->data != toremove){
        last = current;
        current = current->next;
    }
    last->next = current->next;
    return current;

}

int main(){
    timer_data testdata;
    testdata.index = 0;
    testdata.starttime = 293;
    testdata.settime = 60;
    printf("Data entries: %i, %d, %i \n",testdata.index, testdata.starttime, testdata.settime);

    list_element head;
    head.next = NULL;

    add_to_list(&head,&testdata);
    printf("Some stuff I tried: %i \n",head.next->data->starttime);
    
    list_element* test;
    test = remove_from_list(&head, &testdata);
    printf("Does remove work? %i \n",test->data->starttime);
    return 0;
}
