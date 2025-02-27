# Lexical Analyzer
### Test Cases Passed

| Number               | Yes/No |
|----------------------|--------|
| <code>test1</code>   | Y      |
| <code>test2</code>   | Y      |
| <code>test3</code>   | N      |
| <code>test4</code>   | N      |
| <code>test5</code>   | N      |
| <code>test6</code>   | N      |
| <code>preproc</code> | N      |

### Compile <code>Lexer.flex</code>
1. goto <code>src</code> directory

2. copy <i>jflex-1.6.1.jar</i> into src directory

3. compile Lexer.jflex as follows:
```shell
  java -jar jflex-1.6.1.jar Lexer.flex
```
4. compile all java files, or just simply run <code>Program.java</code>

5. run program and capture its output as follows: (Omit this step in dev)
```shell
  java Program test1.minc > solu1.txt
```

