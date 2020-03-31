public class Matrix {
    int M;     //rows       
    int N;     //cols        
    float[][] data;  

    Matrix(int M, int N) 
    {
    //constructor creates random matrix of elements between 1 and -1. 
        this.M = M;
        this.N = N;
        this.data = new float[M][N];
        for (int i = 0; i < M; i++)
        {
            for (int j = 0; j < N; j++)
            {
                this.data[i][j] = (float)(2*(Math.random()) - 1);
            }
        } 
    }

    // return C = A + B
    public Matrix plus(Matrix B) {
        Matrix A = this;
        if (B.M != A.M || B.N != A.N) throw new RuntimeException("Illegal matrix dimensions.");
        Matrix C = new Matrix(M, N);
        for (int i = 0; i < M; i++)
            for (int j = 0; j < N; j++)
                C.data[i][j] = A.data[i][j] + B.data[i][j];
        return C;
    }
    
    // return C = A * B
    Matrix times(Matrix B) {
        Matrix A = this;
        Matrix C = new Matrix(A.M, B.N);
        for (int i = 0; i < C.M; i++)
            for (int j = 0; j < C.N; j++)
                for (int k = 0; k < A.N; k++)
                    C.data[i][j] += (A.data[i][k] * B.data[k][j]);
        return C;
    }
    
    Matrix mapActiveFunc()
    {
      for (int i = 0; i < M; i++)
      {
            for (int j = 0; j < N; j++)
            {
                this.data[i][j] = (float)( 1 / (1 + Math.exp(-1*this.data[i][j])));
            }
      }
      return this;
    }
}
