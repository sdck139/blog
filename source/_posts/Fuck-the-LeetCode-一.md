---
title: Fuck the LeetCode(一)
date: 2017-04-23 19:46:39
tags:
---

### Math

#### 12. Integer to Roman

[原题地址](https://leetcode.com/problems/integer-to-roman/#/description)

这题好玩的是我的解法应该是全网最快的，因为方法很傻

    public class Solution {
        public String intToRoman(int num) {
            String[][] c={
                {"","I","II","III","IV","V","VI","VII","VIII","IX"},
                {"","X","XX","XXX","XL","L","LX","LXX","LXXX","XC"},
                {"","C","CC","CCC","CD","D","DC","DCC","DCCC","CM"},
                {"","M","MM","MMM"}
            };
            StringBuffer roman = new StringBuffer();
            roman.append(c[3][num / 1000 % 10]);
            roman.append(c[2][num / 100 % 10]);
            roman.append(c[1][num / 10 % 10]);
            roman.append(c[0][num % 10]);
             
            return roman.toString();
        }
    }

因为一想反正要识别7个以上的特定字符，干脆就全给你写出来让你自己去匹配，结果就写出了这么蠢的算法，代码很简单不解释了。

#### 13. Roman to Integer

[原题地址](https://leetcode.com/problems/roman-to-integer/#/description)

    public class Solution {
        public int romanToInt(String s) {
            int result = 0;
            boolean isAdd = true;
            for(int i = s.length() - 1; i >= 0; i--) {
                if(i == s.length() - 1) result += romanChatToInt(s.charAt(i));
                else {
                    if(romanChatToInt(s.charAt(i)) < romanChatToInt(s.charAt(i + 1))) isAdd = false;
                    else if(romanChatToInt(s.charAt(i)) > romanChatToInt(s.charAt(i + 1))) isAdd = true;
                    if(isAdd) result += romanChatToInt(s.charAt(i));
                    else result -= romanChatToInt(s.charAt(i));
                }
            }
            return result;
        }
        
        public int romanChatToInt(char c) {
            switch(c) {
                case 'I': return 1;
                case 'V': return 5;
                case 'X': return 10;
                case 'L': return 50;
                case 'C': return 100;
                case 'D': return 500;
                case 'M': return 1000;
                default: break;
            }
            return 0;
        }
    }

这题是上题的兄弟题，思路就是十进制与其他进制的互转加上一个字符转数字的过程，看了一下运算总时间10ms，比最快的快了8倍...真是傻子出奇迹了

### Tree

#### 94. Binary Tree Inorder Traversal

[原题地址](https://leetcode.com/problems/binary-tree-inorder-traversal/#/description)

	public class Solution {
	    public List<Integer> inorderTraversal(TreeNode root) {
	        List<Integer> l = new ArrayList<Integer>();
	        if(root == null) return l;
	        inorder(root, l);
	        return l;
	    }
	    public static void inorder(TreeNode root, List l) {
	        if(root.left != null) inorder(root.left, l);
	        l.add(root.val);
	        if(root.right != null) inorder(root.right, l);
	    }
	}

没啥好说，二叉树中序遍历，inorder那个方法里第二行放在第一行叫先序，放在第三行叫后序

#### 96. Unique Binary Search Trees

[原题地址](https://leetcode.com/problems/unique-binary-search-trees/description/)

```
public class Solution {
  public int numTrees(int n) {
      long result = 1;
      for(int i = n + 1; i <= 2 * n; i ++) {
          result *= i;
          result /= (i - n);
      }
      result /= n + 1;
      return (int)result;
  }
}
```

这题可以看[这个](http://blog.csdn.net/linhuanmars/article/details/24761459)，我用的卡塔兰数的公式

### Backtracking

#### 22. Generate Parentheses

[原题地址](https://leetcode.com/problems/generate-parentheses/#/description)

    class Solution(object):
        def generateParenthesis(self, n):
            """
            :type n: int
            :rtype: List[str]
            """
            result = []
            def addMore(item, left, right, n):
                if left == right == n:
                    result.append(item)
                    return
                if left == n:
                    addMore(item + ")", left, right + 1, n)
                    return
                if left > right:
                    addMore(item + "(", left + 1, right, n)
                    addMore(item + ")", left, right + 1, n)
                    return
                else:
                    addMore(item + "(", left + 1, right, n)
                    return
            addMore("", 0, 0, n)
            return result

这题是回溯算法的基础题了，在我看来回溯算法需要抓住三个点：起始状态，前进规则和结束条件。然后疯狂递归就行了。
比如这题，起始的状态就是一个空字符串。前进的规则就是：左括号数目大于右括号数目时，加左加右都可以，左括号数目等于括号数时，只能加右，其他情况只能加左。结束条件即左右括号数等于括号数。感觉不难理解。

#### 39. Combination Sum

[原题地址](https://leetcode.com/problems/combination-sum/#/description)

    public class Solution {
        public List<List<Integer>> combinationSum(int[] candidates, int target) {
        	int sum = 0;
            List<List<Integer>> l = new LinkedList<List<Integer>>();
            LinkedList<Integer> result = new LinkedList<Integer>();
            LinkedList<LinkedList<Integer>> error = new LinkedList<LinkedList<Integer>>();
            error.add(new LinkedList<Integer>());
            while(error.size() > 1 || error.getFirst().size() != candidates.length) {
                for(int candidate : candidates) {
                    if(!error.getLast().contains(candidate)) {
                    	if(!result.isEmpty()) {
                    		if(candidate < result.getLast()) {
                    			error.getLast().add(candidate);
                    			continue;
                    		}
                    	}
                        if(sum + candidate < target) {
                            result.add(candidate);
                            sum += candidate;
                            error.add(new LinkedList<Integer>());
                            break;
                        } else if(sum + candidate == target) {
                            result.add(candidate);
                            LinkedList<Integer> temp = new LinkedList<Integer>();
                            temp = (LinkedList<Integer>) result.clone();
                            l.add(temp);
                            result.removeLast();
                            error.getLast().add(candidate);
                        } else { 
                            error.getLast().add(candidate);
                        }
                    }
                    if(error.getLast().size() == candidates.length && error.size() > 1) {
                        error.removeLast();
                        int temp = result.removeLast();
                        sum -= temp;
                        error.getLast().add(temp);
                        break;
                    }
                }
            }
            return l;
        }
    }

上面的代码是我年轻时写的，现在已然看不懂了...
也懒得去理解了，仔细看了一下题目，发现又是一道回溯题，起始条件是空数组，前进规则是把当前位置之后的所有数都放进去试试，结束条件是数组之和等于target就加进result，大于target就return，以下是新代码

    class Solution(object):
        def combinationSum(self, candidates, target):
            """
            :type candidates: List[int]
            :type target: int
            :rtype: List[List[int]]
            """
            result = []
            length = len(candidates)
            def search(temp, start, target):
                if target < 0:
                    return
                if target == 0:
                    result.append(temp)
                    return
                for i in range(start, length):
                    temp.append(candidates[i])
                    search(list(temp), i, target - candidates[i])
                    temp.pop()
            search([], 0, target)
            return result

然而不知道为啥运行了223ms...

#### 89. Gray Code

[原题地址](https://leetcode.com/problems/gray-code/#/description)

	class Solution:
	    '''
	    from up to down, then left to right
	    
	    0   1   11  110
	            10  111
	                101
	                100
	                
	    start:      [0]
	    i = 0:      [0, 1]
	    i = 1:      [0, 1, 3, 2]
	    i = 2:      [0, 1, 3, 2, 6, 7, 5, 4]
	    '''
	    def grayCode(self, n):
	        results = [0]
	        for i in range(n):
	            results += [x + pow(2, i) for x in reversed(results)]
	        return results

格雷码编码方式，笔者很累，就不解释了。

### Dynamic Programming

#### 53. Maximum Subarray

[原题地址](https://leetcode.com/problems/maximum-subarray/#/description)

	public class Solution {
	    public int maxSubArray(int[] nums) {
	        int localMax = nums[0];
	        int globalMax = nums[0];
	        for (int i = 1; i < nums.length; i++) {
	            localMax = Math.max(localMax + nums[i], nums[i]);
	            globalMax = Math.max(globalMax, localMax);
	        }
	        return globalMax;
	    }
	}

这是一道动态规划（Dynamic Programming）题，关于DP算法我是看这篇[文章](http://www.hawstein.com/posts/dp-novice-to-advanced.html)学的，目前遇到这种题也是很慌的。
回到这题，若我们已经解决了前n-1个数的结果，那我们就把那个结果跟第n个数加加看，如果加完后比第n个数大，那就加，否则就以第n个数为新的最大值，当然，这个值只是局部的，我们还要将它与前n-1个数的真实最大值比较，求最大值。

#### 62. Unique Paths

[原题地址](https://leetcode.com/problems/unique-paths/#/description)

这题我去年提交的代码是这个

	public class Solution {
	    public int uniquePaths(int m, int n) {
	        long result = 1;
	        int x = (m < n ? m : n) - 1;
	        int sum = m + n - 2;
	        for(int i = 0; i < x; i++) {
	            result *= (sum - i);
	            result /= i + 1;
	        }
	        return (int)result;
	    }
	}

因为很显然这是一道组合题，答案是C（m - 1, m + n -2）。不过今天又看了一下，发现可以用DP算法做，于是有了如下代码：

	class Solution(object):
	    def uniquePaths(self, m, n):
	        map = [[1 for j in range(n)] for i in range(m)]
	        for i in range(1, m):
	            for j in range(1, n):
	                map[i][j] = map[i - 1][j] + map[i][j - 1]
	        print(map)
	        return map[m-1][n-1]

由于机器人只能像右或向下走，那么顶部和左侧每一个到达的方法都只有一种，直行，因此记为1。而其他格子到达的路径数等于其上面的格子与左边的格子到达的路径数之和。

#### 70. Climbing Stairs

[原题地址](https://leetcode.com/problems/climbing-stairs/#/description)

	public class Solution {
	    public int climbStairs(int n) {
	        if(n <= 1) return 1;
	        int fn_1 = 1;
	        int fn_2 = 1;
	        int fn = fn_1 + fn_2;
	        while(n > 2) {
	        	fn_2 = fn_1;
	            fn_1 = fn;
	            fn = fn_1 + fn_2;
	            n--;
	        }
	        return fn;
	    }
	}

可以说是DP题的始祖了，传说中的青蛙跳台阶问题（+1s）。思路是跳到第n阶的路径数等于第n-1阶与第n-2阶之和。