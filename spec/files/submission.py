output = open("output.txt", "w")
for line in open("input.txt", "r"):
    output.write(str(sum([int(x) for x in line.split()])))
    output.write("\n")
output.close()
