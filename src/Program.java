/**
 * Authors:
 * - Aman Sahu - ajs9219@psu.edu
 * - Aadil Kakkidi - ajk6909@psu.edu
 */

public class Program {
    public static void main(String[] args) throws Exception
    {
        java.io.Reader r;

        r = new java.io.StringReader
        ("int main()\n"
        +"{\n"
        +"    return 0;\n"
        +"}\n"
        );

        args = new String[] { "test/test6.minc" };

        if(args.length <= 0)
            return;
        r = new java.io.FileReader(args[0]);

        Compiler compiler = new Compiler(r);
        compiler.Compile();
    }
}
