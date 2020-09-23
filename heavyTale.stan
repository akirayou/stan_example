parameters {
    vector[2] x;
}
model {
    target += -pow(square(x[1])+square(x[2]),0.05);
}