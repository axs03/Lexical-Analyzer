# Lexical Analyzer

## Authors
- Aman Sahu  
- Aadil Kakkidi
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
Finally!

1. go to <code>src</code> directory
### Modify `Program.java`
2. update `Program.java` to set the test case path in the `args` array:  
```java
  args = new String[] { "\\test\\test1.minc" };
```
### Compile <code>Lexer.flex</code>
3. compile Lexer.jflex as follows:
```shell
  java -jar jflex-1.6.1.jar Lexer.flex
```
### Compile * files
4. compile all java files, or just simply run <code>Program.java</code>
```shell
  javac *.java
```
### Get Output

5. run program and capture its output as follows: (Omit this step in dev)
```shell
  java Program test1.minc > solu1.txt
```

