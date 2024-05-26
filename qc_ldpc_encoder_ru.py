import numpy as np

h_matrix = np.array([[1,1,0,0,1,1,0,1,0,0,0,1],
                   [1,1,1,0,0,1,1,0,1,0,0,0],
                   [0,0,0,1,1,0,0,1,1,1,0,1],
                   [0,0,1,1,0,1,0,0,1,1,1,0],
                   [1,0,1,0,0,0,1,0,0,1,1,1],
                   [0,1,0,1,1,0,1,1,0,0,1,0]])

A = h_matrix[:4,:6]
print("A \n",A)
B= h_matrix[:4,6:8]
print("B\n",B)
C=h_matrix[:4,8:12]
print("C\n",C)
D=h_matrix[4:6,:6]
print("D\n",D)
E=h_matrix[4:6,6:8]
print("E\n",E)
F=h_matrix[4:6,8:12]
print("F\n",F)

s1= np.array([0,1,1,0,1,0])
s1 = np.array([s1])
print("S1\n",s1)

s1_trans = s1.reshape(-1, 1)


def mult(matrix1, matrix2):
    if len(matrix1[0]) != len(matrix2):
        raise ValueError("Number of columns in the first matrix must be equal to the number of rows in the second matrix.")
    result = [[0 for _ in range(len(matrix2[0]))] for _ in range(len(matrix1))]

    for i in range(len(matrix1)):
        for j in range(len(matrix2[0])):
            for k in range(len(matrix2)):
                result[i][j] ^= matrix1[i][k] & matrix2[k][j]
    # return result
    return np.array(result)
    
print("F * C:\n", mult(F,C))
print("F * C * A:\n", mult(mult(F,C),A))
R1_T = mult(mult(mult(F,C),A),s1_trans)
print("\nR1_T \n" , R1_T)

R1 = R1_T.reshape(1, -1)
print("\nR1 \n" , R1)

print("A * S_T:\n",mult(A,s1_trans))
print("C * A * S_T:\n",mult(C, mult(A,s1_trans)))
print("B * R1_T:\n", mult(B,R1_T))
R2_T = np.bitwise_or(mult(C, mult(A,s1_trans)), mult(B,R1_T))
print("R2_T:\n", R2_T)

R2 = R2_T.reshape(1, -1)
print("R2:\n", R2)


Encoded_codeword = np.concatenate((s1,R1,R2), axis=1)
print("Encoded_codeword:\n", Encoded_codeword)

