# CMPSC 470 Lexical Analyzer Project 3

## Authors
- Aman Sahu - ajs9219@psu.edu
- Aadil Kakkidi - ajk6909@psu.edu
### Test Cases Passed
| Number               | Yes/No |
|----------------------|--------|
| <code>test1</code>   | Y      |
| <code>test2</code>   | Y      |
| <code>test3</code>   | Y      |
| <code>test4</code>   | Y      |
| <code>test5</code>   | Y      |
| <code>test6</code>   | Y      |
| <code>preproc</code> | Y      |


1. go to <code>src</code> directory
### Modify `Program.java`
2. update `Program.java` to set the test case path in the `args` array:  
```java
  args = new String[] { "<PATH_TO_TEST_FILE>" };
```
### Compile <code>Lexer.flex</code>
3. compile <code>Lexer.jflex</code> as follows:
```shell
  java -jar jflex-1.6.1.jar Lexer.flex
```
### Compile Java files
4. compile all java files, or just simply run <code>Program.java</code>
```shell
  javac *.java
```
### Get Output
5. run program and capture its output as follows: (Omit this step in development)
```shell
  java Program test1.minc > solu1.txt
```

