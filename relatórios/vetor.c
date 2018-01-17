#include <stdio.h>
#include <stdlib.h>
#include <math.h>

double norma(unsigned tam, double vetor[]) {
	double sum = 0;
	for (int i = 0; i < tam; i++) {
		sum += vetor[i]*vetor[i];
	}
	return sqrt(sum);
}

void mult_escalar(unsigned tam, double vetor[], double escalar) {
	for (int i = 0; i < tam; i++) {
		vetor[i] = vetor[i] * escalar;
	}
}

double* soma(unsigned tam, double a[], double b[]) {
	double* c = malloc(tam);
	for (int i = 0; i < tam; i++) {
		c[i] = a[i] + b[i];
	}
	return c;
}

double* prod_escalar(unsigned tam, double a[], double b[]) {
	double* c = malloc(tam * sizeof(double));
	for (int i = 0; i < tam; i++) {
		c[i] = a[i] * b[i];
	}
	return c;
}

double* prod_vetorial(double a[3], double b[3]) {
	double* c = malloc(3 * sizeof(double));
	c[0] = a[1]*b[2] - b[1]*a[2];
	c[1] = -a[0]*b[2] + b[0]*a[2];
	c[2] = a[0]*b[1] - b[0]*a[1];
	return c;
}

void transposicao(unsigned x, unsigned y, double matriz[][x], double out[][x]) {
	for (int i = 0; i < y; i++) {
		for (int j = 0; j < x; j++) {
			out[j][i] = matriz[i][j];
		}
	}
}

void mult_escalar_matriz(unsigned x, unsigned y, double matriz[][x], double out[][x], int escalar) {
	for (int i = 0; i < y; i++) {
		for (int j = 0; j < x; j++) {
			out[i][j] = matriz[i][j] * escalar;
		}
	}
}

void soma_matriz(unsigned x, unsigned y, double a[][x], double b[][x], double c[][x]) {
	for (int i = 0; i < y; i++) {
		for (int j = 0; j < x; j++) {
			c[i][j] = a[i][j] + b[i][j];
		}
	}
}

void mult_matriz(unsigned x, unsigned y, double a[][x], double b[][x], double c[][x]) {
	for (int i = 0; i < y; i++) {
		for (int j = 0; j < x; j++) {
			double soma = 0;
			for (int k = 0; k < y; k++)
				soma += a[i][k] * b[k][j];
			c[i][j] = soma;
		}
	}
}

double determinante(double matriz[3][3]) {
	double det = 0;

	det += matriz[0][0] * matriz[1][1] * matriz[2][2];
	det += matriz[0][1] * matriz[1][2] * matriz[2][0];
	det += matriz[0][2] * matriz[1][0] * matriz[2][1];

	det -= matriz[0][2] * matriz[1][1] * matriz[2][0];
	det -= matriz[0][0] * matriz[1][2] * matriz[2][1];
	det -= matriz[0][1] * matriz[1][0] * matriz[2][2];

	return det;
}

int main() {
	return 0;
}
