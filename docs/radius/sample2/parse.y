class MyParser
rule

    all_stmt : stmt stmt
             | stmt

end

---- inner
def parse(source)