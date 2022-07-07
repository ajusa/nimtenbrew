import nimtenbrew/ctr/icon

let png = icon.load("./tests/data/ctr/test.png", 48)
let data = icon.convertPNGToIcon(png)

let file = io.open("test.dat", fmWrite)
file.write(data)
file.close()
