using System;
using System.Collections.Generic;


namespace Tower
{
    class TowerOfHanoi
    {














        static public bool SolveTOH(int nDiscs, Stack<int> source, Stack<int> temp, Stack<int> dest)
        {Console.WriteLine("\nORBS:"+ nDiscs + "\n");
            if (nDiscs <= 4)
            {
                if ((nDiscs % 2) == 0)
                {

                    nDiscs = nDiscs - 1;
                    if (nDiscs == 1)
                        return true;










                    SolveTOH(nDiscs, temp, source, dest);











                }
                return true;
            }

            {
                SolveTOH(nDiscs - 2, source, temp, dest);



                SolveTOH(nDiscs - 2, dest, source, temp);



                SolveTOH(nDiscs - 1, temp, source, dest);
            }



























            return true;
        }

        static public Stack<int> A = new Stack<int>();
        static public Stack<int> B = new Stack<int>();
        static public Stack<int> C = new Stack<int>();
































































        static void Main(string[] args)
        {

            {

                string s = Console.ReadLine();

                int maxdisc = Convert.ToInt32(s);










                for (int i = maxdisc; i >= 1; i--)
                    A.Push(i);




                SolveTOH(maxdisc, A, B, C);





            }
        }
    }
}
