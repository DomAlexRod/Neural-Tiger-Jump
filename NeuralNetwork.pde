public class NeuralNetwork
{
  //Neural network for only one hidden layer (with three nodes) and one output and 3 inputs
  int numOfInputs = 3;
  int numOfHiddenNodes = 6;
  int numOfOutputs = 1;
  float mutationRate = 0.05;
  Matrix inWeights;
  Matrix outWeights;
  Matrix inBias;
  Matrix outBias;

  NeuralNetwork()
  {
    inWeights = new Matrix(numOfHiddenNodes, numOfInputs);
    outWeights = new Matrix(numOfOutputs, numOfHiddenNodes);
    
    inBias = new Matrix(numOfHiddenNodes, 1);
    outBias = new Matrix(numOfOutputs, 1);
  }
  
  float result(float a, float b, float c)
  {
    Matrix inputData = new Matrix(numOfInputs,1);
    inputData.data[0][0] = a;
    inputData.data[1][0] = b;
    inputData.data[2][0] = c;
    
    Matrix firstLayerComplete = inWeights.times(inputData).plus(inBias).mapActiveFunc() ;
    Matrix outPut = outWeights.times(firstLayerComplete).plus(outBias).mapActiveFunc();
    
    return outPut.data[0][0];
  }
  
  private float mutateVariable(float var)
  {
      var += random(-1,1); 
      if (var > 1)
      {
        return 1;
      }
      else if ( var < - 1)
      {
        return -1;
      }
      else
      {  
      return var;
      }
  }
  
  
  private void mutateMatrix(Matrix objectToMutate)
  {
    for (int i = 0; i < objectToMutate.M; i++)
    {
      for (int j = 0; j < objectToMutate.N; j++)
      {
        if (random(1) < mutationRate)
        {
          objectToMutate.data[i][j] = mutateVariable(objectToMutate.data[i][j]); 
        }
      }
    }
  }
  
  NeuralNetwork mutateNetwork()
  {
    //to be called to evolve whole neural network.
    mutateMatrix(inWeights);
    mutateMatrix(outWeights);
    mutateMatrix(inBias);
    mutateMatrix(outBias);
    
    return this;
  }
    
  
  NeuralNetwork duplicate()
  {
    return this;
  }
  
}  
