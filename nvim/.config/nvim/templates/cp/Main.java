// problem-url: $(URL)
// Problem: $(PROBLEM)
// Contest: $(CONTEST)
// Judge: $(JUDGE)
// Time Limit: $(TIMELIM) ms
// Memory Limit: $(MEMLIM)
// Received: $(DATE)

import static java.lang.Math.max;
import static java.lang.Math.min;
import static java.lang.Math.abs;

import java.util.*;
import java.io.*;
import java.nio.charset.StandardCharsets;
// import java.nio.file.*;
import java.math.*;
import java.util.function.*;

// @SuppressWarnings("resource")
public final class Main {

  static PrintWriter out = new PrintWriter(System.out);
  static PrintWriter err = new PrintWriter(System.err);
  static final boolean LOCAL = System.getProperty("LOCAL") != null;

  static void debug(Object... args) {
    if (!LOCAL)
      return;
    err.println(Arrays.deepToString(args));
  }

  static FastReader in = new FastReader();
  static final int MOD1 = (int) (1e9 + 7);
  static final int MOD2 = 998244353;

  static final int inf = Integer.MAX_VALUE;
  static final int minf = Integer.MIN_VALUE;
  static final long linf = 1L << 62;

  public static void main(String[] args) {
    int tt = i();
    while (tt-- > 0) {
      solve();
    }
    out.flush();
    err.flush();
  }

  public static void solve() {

    // PriorityQueue<Integer> pq = new PriorityQueue<>(Collections.reverseOrder());

    int n = i();
    // long k = l();
    // char s[] = s().toCharArray();
    // int ar[]=input(n);
    // long ar[]=inputLong(n);

    // pl();
  }

  static int BinarySearch(long ar[], int k) {
    int lo = 0;
    int hi = ar.length - 1;
    int mid;
    int ans = -1;
    while (lo <= hi) {
      mid = lo + ((hi - lo) / 2);
      if (ar[mid] >= k) {
        ans = mid;
        hi = mid - 1;
      } else {
        lo = mid + 1;
      }
    }
    return ans;
  }

  // ------------------------------------------COMMON|FUNCTIONS--------------------------------------------------//

  // -------------BINARYSEARCH-----------//

  // UPPERBOUND find lowest i which satisfy a[i]>=x
  static int upperbound(List<Integer> a, int x) {
    int l = 0;
    int r = a.size() - 1;
    while (l < r) {
      int m = l + (r - l) / 2;
      if (a.get(m) >= x) {
        r = m;
      } else {
        l = m + 1;
      }

    }
    return r;
  }

  static int upperbound(List<Long> a, long x) {
    int l = 0;
    int r = a.size() - 1;
    while (l < r) {
      int m = l + (r - l) / 2;
      if (a.get(m) >= x) {
        r = m;
      } else {
        l = m + 1;
      }

    }
    return r;
  }

  static int upperbound(int[] a, int x) {
    int l = 0;
    int r = a.length - 1;
    while (l < r) {
      int m = l + (r - l) / 2;
      if (a[m] >= x) {
        r = m;
      } else {
        l = m + 1;
      }

    }
    return r;
  }

  static int upperbound(long[] a, long x) {
    int l = 0;
    int r = a.length - 1;
    while (l < r) {
      int m = l + (r - l) / 2;
      if (a[m] >= x) {
        r = m;
      } else {
        l = m + 1;
      }

    }
    return r;
  }

  // LOWERBOUND find highest i which satisfy a[i]<=x
  static int lowerbound(List<Long> a, long x) {
    int l = 0;
    int r = a.size() - 1;
    while (l < r) {
      int m = (l + r + 1) / 2;
      if (a.get(m) <= x) {
        l = m;
      } else {
        r = m - 1;
      }
    }
    return l;
  }

  static int lowerbound(List<Integer> a, int x) {
    int l = 0;
    int r = a.size() - 1;
    while (l < r) {
      int m = (l + r + 1) / 2;
      if (a.get(m) <= x) {
        l = m;
      } else {
        r = m - 1;
      }
    }
    return l;
  }

  static int lowerbound(int[] a, int x) {
    int l = 0;
    int r = a.length - 1;
    while (l < r) {
      int m = (l + r + 1) / 2;
      if (a[m] <= x) {
        l = m;
      } else {
        r = m - 1;
      }
    }
    return l;
  }

  static int lowerbound(long[] a, long x) {
    int l = 0;
    int r = a.length - 1;
    while (l < r) {
      int m = (l + r + 1) / 2;
      if (a[m] <= x) {
        l = m;
      } else {
        r = m - 1;
      }
    }
    return l;
  }

  // -------------BINARYSEARCH-----------//

  // ---------------MATH-----------------//

  public static long fact(int n, int mod) {
    long res = 1;
    for (int i = 2; i <= n; i++) {
      res = (res * i) % mod;
    }
    return res;
  }

  static int GCD(int a, int b) {
    int dividend = a > b ? a : b;
    int divisor = a < b ? a : b;

    while (divisor > 0) {
      int reminder = dividend % divisor;
      dividend = divisor;
      divisor = reminder;
    }
    return dividend;
  }

  static long GCD(long a, long b) {
    long dividend = a > b ? a : b;
    long divisor = a < b ? a : b;

    while (divisor > 0) {
      long reminder = dividend % divisor;
      dividend = divisor;
      divisor = reminder;
    }
    return dividend;
  }

  static long LCM(int a, int b) {
    return (long) a / GCD(a, b) * b;
  }

  static long LCM(long a, long b) {
    return a / GCD(a, b) * b;
  }

  static long pow(long a, long b, int mod) {
    long pow = 1;
    long x = a;
    while (b != 0) {
      if ((b & 1) != 0) {
        pow = (pow * x) % mod;
      }
      x = (x * x) % mod;
      b /= 2;
    }
    return pow;
  }

  static long pow(long a, long b) {
    long pow = 1;
    long x = a;
    while (b != 0) {
      if ((b & 1) != 0) {
        pow *= x;
      }
      x = x * x;
      b /= 2;
    }
    return pow;
  }

  static long modInverse(long x, int mod) {
    return pow(x, mod - 2, mod);
  }

  static boolean isPrime(long N) {
    if (N <= 1) {
      return false;
    }
    if (N <= 3) {
      return true;
    }
    if (N % 2 == 0 || N % 3 == 0) {
      return false;
    }
    for (int i = 5; i * i <= N; i = i + 6) {
      if (N % i == 0 || N % (i + 2) == 0) {
        return false;
      }
    }
    return true;
  }

  static long log(long a) {
    return (long) (Math.log(a));
  }

  static long log2(long a) {
    return (long) (Math.log(a) / Math.log(2));
  }

  static long sqrt(long x) {
    long start = 0, end = (long) 3e9, ans = 1;
    while (start <= end) {
      long mid = (start + end) / 2;
      if (mid * mid <= x) {
        ans = mid;
        start = mid + 1;
      } else
        end = mid - 1;
    }
    return ans;
  }

  static long ceil(long a, long b) {
    return (a / b) + ((a % b == 0) ? 0 : 1);
  }

  static boolean isPerfectSquare(double number) {
    double sqrt = Math.sqrt(number);
    return ((sqrt - Math.floor(sqrt)) == 0);
  }

  // ---------------MATH-----------------//
  // ---------------CALCS-----------------//

  static long sum(List<Long> a) {
    long sum = 0;
    for (long ele : a)
      sum += ele;
    return sum;
  }

  static long sum(int[] a) {
    long sum = 0;
    for (int ele : a)
      sum += ele;
    return sum;
  }

  static long sum(long[] a) {
    long sum = 0;
    for (long ele : a)
      sum += ele;
    return sum;
  }

  static int maxArray(long a[]) {
    int in = 0;
    long m = a[0];
    for (int i = 1; i < a.length; i++) {
      if (a[i] > m) {
        m = a[i];
        in = i;
      }
    }
    return in;
  }

  static int maxArray(int a[]) {
    int in = 0;
    int m = a[0];
    for (int i = 1; i < a.length; i++) {
      if (a[i] > m) {
        m = a[i];
        in = i;
      }
    }
    return in;
  }

  static int minArray(long a[]) {
    int in = 0;
    long m = a[0];
    for (int i = 1; i < a.length; i++) {
      if (a[i] < m) {
        m = a[i];
        in = i;
      }
    }
    return in;
  }

  static int minArray(int a[]) {
    int in = 0;
    int m = a[0];
    for (int i = 1; i < a.length; i++) {
      if (a[i] < m) {
        m = a[i];
        in = i;
      }
    }
    return in;
  }

  // ---------------CALCS-----------------//

  // ------------------------------------------COMMON|FUNCTIONS--------------------------------------------------//

  // ------------------------------------------MODIFICATIONS--------------------------------------------------//

  static void shuffle(int[] arr) {
    for (int i = 0; i < arr.length; i++) {
      int rand = (int) (Math.random() * arr.length);
      int temp = arr[rand];
      arr[rand] = arr[i];
      arr[i] = temp;
    }
  }

  static void shuffleAndSort(int[] arr) {
    for (int i = 0; i < arr.length; i++) {
      int rand = (int) (Math.random() * arr.length);
      int temp = arr[rand];
      arr[rand] = arr[i];
      arr[i] = temp;
    }
    Arrays.sort(arr);
  }

  static void shuffleAndSort(long[] arr) {
    for (int i = 0; i < arr.length; i++) {
      int rand = (int) (Math.random() * arr.length);
      long temp = arr[rand];
      arr[rand] = arr[i];
      arr[i] = temp;
    }
    Arrays.sort(arr);
  }

  static void swap(int A[], int a, int b) {
    int t = A[a];
    A[a] = A[b];
    A[b] = t;
  }

  static void swap(long A[], int a, int b) {
    long t = A[a];
    A[a] = A[b];
    A[b] = t;
  }

  static void swap(char A[], int a, int b) {
    char t = A[a];
    A[a] = A[b];
    A[b] = t;
  }

  public static String reverse(String str) {
    if (str == null) {
      return null;
    }
    return new StringBuilder(str).reverse().toString();
  }

  public static void reverse(int[] arr) {
    int l = 0;
    int r = arr.length - 1;
    while (l < r) {
      swap(arr, l, r);
      l++;
      r--;
    }
  }

  public static void reverse(long[] arr) {
    int l = 0;
    int r = arr.length - 1;
    while (l < r) {
      swap(arr, l, r);
      l++;
      r--;
    }
  }

  public static String repeat(char ch, int repeat) {
    if (repeat <= 0) {
      return "";
    }
    final char[] buf = new char[repeat];
    for (int i = repeat - 1; i >= 0; i--) {
      buf[i] = ch;
    }
    return new String(buf);
  }

  public static String repeat(char ch[], int repeat) {
    if (repeat <= 0) {
      return "";
    }
    final char[] buf = new char[repeat];
    for (int i = 0; i < repeat; i++) {
      buf[i] = ch[i % ch.length];
    }
    return new String(buf);
  }

  public static String repeat(String ch, int repeat) {
    if (repeat <= 0) {
      return "";
    }
    final char[] buf = new char[repeat];
    for (int i = 0; i < repeat; i++) {
      buf[i] = ch.charAt(i % ch.length());
    }
    return new String(buf);
  }

  static void fillFrequency(Map<Long, Integer> map, long a[]) {
    for (int i = 0; i < a.length; i++) {
      fill(map, a[i]);
    }
  }

  static void fill(Map<Long, Integer> map, long val) {
    if (map.containsKey(val))
      map.put(val, map.get(val) + 1);
    else
      map.put(val, 1);
  }

  static void fillFrequency(Map<Integer, Integer> map, int a[]) {
    for (int i = 0; i < a.length; i++) {
      fill(map, a[i]);
    }
  }

  static void fill(Map<Integer, Integer> map, int val) {
    if (map.containsKey(val))
      map.put(val, map.get(val) + 1);
    else
      map.put(val, 1);
  }

  static void remove(Map<Long, Integer> map, long val) {
    if (map.get(val) == 1)
      map.remove(val);
    else
      map.replace(val, map.get(val) - 1);
  }

  static void remove(Map<Integer, Integer> map, int val) {
    if (map.get(val) == 1)
      map.remove(val);
    else
      map.replace(val, map.get(val) - 1);
  }

  // ------------------------------------------MODIFICATIONS--------------------------------------------------//
  // //
  // -----------------------------------------------PRECOMPUTE--------------------------------------------------//

  // --------------BITS-----------------//
  static int[][] PrefixBitsCount(int n, int[] a) {
    int pref[][] = new int[n + 1][32];
    // Builds the prefix sums for each bit
    for (int i = 0; i < n; i++) {
      for (int j = 0; j < 32; j++) {
        if ((a[i] & (1 << j)) != 0) {
          pref[i + 1][j] = pref[i][j] + 1;
        } else {
          pref[i + 1][j] = pref[i][j];
        }
      }
    }
    return pref;
  }

  static int[] prefixAnd(int[] a) {
    int[] pre = new int[a.length];
    pre[0] = a[0];
    for (int i = 1; i < a.length; i++) {
      pre[i] = pre[i - 1] & a[i];
    }
    return pre;
  }

  static int[] prefixOr(int[] a) {
    int[] pre = new int[a.length];
    pre[0] = a[0];
    for (int i = 1; i < a.length; i++) {
      pre[i] = pre[i - 1] | a[i];
    }
    return pre;
  }

  static int[] prefixXor(int[] a) {
    int[] pre = new int[a.length];
    pre[0] = a[0];
    for (int i = 1; i < a.length; i++) {
      pre[i] = pre[i - 1] ^ a[i];
    }
    return pre;
  }
  // --------------BITS-----------------//

  // --------------ARRAYS-----------------//

  static int[] getPrefMax(int arr[]) {
    int n = arr.length;
    int pref[] = new int[n];
    pref[0] = arr[0];
    for (int i = 1; i < n; i++) {
      pref[i] = max(arr[i], pref[i - 1]);
    }
    return pref;
  }

  static int[] getPrefMin(int arr[]) {
    int n = arr.length;
    int pref[] = new int[n];
    pref[0] = arr[0];
    for (int i = 1; i < n; i++) {
      pref[i] = min(arr[i], pref[i - 1]);
    }
    return pref;
  }

  static int[] getSuffMin(int arr[]) {
    int n = arr.length;
    int suff[] = new int[n];
    suff[n - 1] = arr[n - 1];
    for (int i = n - 2; i >= 0; i--) {
      suff[i] = min(suff[i + 1], arr[i]);
    }
    return suff;
  }

  static long[] prefix(int[] a) {
    long[] pre = new long[a.length + 1];
    pre[0] = 0;
    for (int i = 0; i < a.length; i++) {
      pre[i + 1] = pre[i] + a[i];
    }
    return pre;
  }

  static List<Long> prefix(List<Integer> a) {
    List<Long> pre = new ArrayList<>();
    pre.add(0l);
    for (int i = 0; i < a.size(); i++) {
      pre.add(pre.get(i) + a.get(i));
    }
    return pre;
  }

  static long[] prefix(long[] a) {
    long[] pre = new long[a.length + 1];
    pre[0] = 0;
    for (int i = 0; i < a.length; i++) {
      pre[i + 1] = pre[i] + a[i];
    }
    return pre;
  }

  static long[] suffix(int[] a) {
    long[] post = new long[a.length + 1];
    post[a.length] = 0;
    for (int i = a.length - 1; i >= 0; i++) {
      post[i] = post[i + 1] + a[i];
    }
    return post;
  }

  static long[] suffix(long[] a) {
    long[] post = new long[a.length + 1];
    post[a.length] = 0;
    for (int i = a.length - 1; i >= 0; i++) {
      post[i] = post[i + 1] + a[i];
    }
    return post;
  }
  // --------------ARRAYS-----------------//

  // --------------Sieve&Factors-----------------//

  static List<Integer> sieveOfEratosthenes(int n) {
    List<Integer> primeList = new ArrayList<>();
    boolean prime[] = new boolean[n + 1];
    for (int i = 0; i <= n; i++)
      prime[i] = true;

    for (int p = 2; p * p <= n; p++) {

      if (prime[p] == true) {

        for (int i = p * p; i <= n; i += p)
          prime[i] = false;
      }
    }

    for (int i = 2; i <= n; i++) {
      if (prime[i] == true)
        primeList.add(i);
      // System.out.print(i + " ");
    }
    return primeList;
  }

  static List<Integer> allDivisors(int n) {
    List<Integer> divisoers = new ArrayList<>();
    for (int i = 1; i * i <= n; i++) {
      if (n % i == 0) {
        divisoers.add(i);
        if (i != n / i) {
          divisoers.add(n / i);
        }
      }
    }
    return divisoers;
  }

  // --------------Sieve&Factors-----------------//

  // -----------------------------------------------PRECOMPUTE--------------------------------------------------//

  // ---------------------------------------------INPUT&OUTPUT--------------------------------------------------//

  static int i() {
    return in.nextInt();
  }

  static long l() {
    return in.nextLong();
  }

  static double d() {
    return in.nextDouble();
  }

  static String s() {
    return in.nextLine();
  }

  static ArrayList<Integer> inputList(int n) {
    ArrayList<Integer> a = new ArrayList<Integer>(n);
    for (int i = 0; i < n; i++)
      a.add(i());
    return a;
  }

  static ArrayList<Long> inputListLong(int n) {
    ArrayList<Long> a = new ArrayList<Long>(n);
    for (int i = 0; i < n; i++)
      a.add(l());
    return a;
  }

  static int[][] inputWithIdx(int N) {
    int A[][] = new int[N][2];
    for (int i = 0; i < N; i++) {
      A[i] = new int[] { in.nextInt(), i };
    }
    return A;
  }

  static int[][] inputMatrix(int N, int M) {
    int A[][] = new int[N][M];
    for (int i = 0; i < N; i++) {
      for (int j = 0; j < M; j++) {
        A[i][j] = i();
      }
    }
    return A;
  }

  static long[][] inputMatrixLong(int N, int M) {
    long A[][] = new long[N][M];
    for (int i = 0; i < N; i++) {
      for (int j = 0; j < M; j++) {
        A[i][j] = i();
      }
    }
    return A;
  }

  static int[] input(int N) {
    int A[] = new int[N];
    for (int i = 0; i < N; i++) {
      A[i] = in.nextInt();
    }
    return A;
  }

  static Integer[] inputWrapper(int N) {
    Integer A[] = new Integer[N];
    for (int i = 0; i < N; i++) {
      A[i] = in.nextInt();
    }
    return A;
  }

  static long[] inputLong(int N) {
    long A[] = new long[N];
    for (int i = 0; i < A.length; i++) {
      A[i] = in.nextLong();
    }
    return A;
  }

  static void p(String s) {
    out.print(s);
  }

  static void p(int s) {
    out.print(s);
  }

  static void p(long s) {
    out.print(s);
  }

  static void p(double s) {
    out.print(s);
  }

  static void p(char s) {
    out.print(s);
  }

  static void pl(String s) {
    out.println(s);
  }

  static void pl(int s) {
    out.println(s);
  }

  static void pl(long s) {
    out.println(s);
  }

  static void pl(double s) {
    out.println(s);
  }

  static void pl(char c) {
    out.println(c);
  }

  static void pl() {
    out.println();
  }

  static void pl(int[] o) {
    for (int i = 0; i < o.length; i++) {
      out.print(o[i] + " ");
    }
    out.println();
  }

  static void pl(long[] o) {
    for (int i = 0; i < o.length; i++) {
      out.print(o[i] + " ");
    }
    out.println();
  }

  static <T> void pl(T[] o) {
    for (int i = 0; i < o.length; i++) {
      out.print(o[i] + " ");
    }
    out.println();
  }

  static <T> void pl(List<T> A) {
    for (T a : A) {
      out.print(a + " ");
    }
    out.println();
  }

  static void pl(Object o) {
    out.println(o);
  }

  static void ps(int s) {
    out.print(s + " ");
  }

  static void ps(long s) {
    out.print(s + " ");
  }

  static void ps(double s) {
    out.print(s + " ");
  }

  static void ps(char c) {
    out.print(c + " ");
  }

  static void yes() {
    pl("YES");
  }

  static void no() {
    pl("NO");
  }

  // ---------------------------------------------INPUT&OUTPUT--------------------------------------------------//

}

class FastReader {

  BufferedReader br;
  StringTokenizer st;

  public FastReader() {
    br = new BufferedReader(new InputStreamReader(System.in));
  }

  public FastReader(InputStream is) {
    br = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8));
  }

  String next() {
    while (st == null || !st.hasMoreElements()) {
      try {
        st = new StringTokenizer(br.readLine());
      } catch (IOException e) {
        e.printStackTrace();
      }
    }
    return st.nextToken();
  }

  char nextChar() {
    return next().charAt(0);
  }

  int nextInt() {
    return Integer.parseInt(next());
  }

  long nextLong() {
    return Long.parseLong(next());
  }

  double nextDouble() {
    return Double.parseDouble(next());
  }

  String nextLine() {
    String str = "";
    try {
      str = br.readLine();
    } catch (IOException e) {
      e.printStackTrace();
    }
    return str;
  }
}
