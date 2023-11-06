// print_chars
// add scrolling
// IVT + capture keystrokes

void main() {
    char str[] = "hello_world!!";
    char* video_memory = (char *) 0xb8000;
    for (int i = 0;str[i] != 0;i++)
        *(video_memory + i*2) = str[i];

}