// Problem: $(PROBLEM)
// Contest: $(CONTEST)
// Judge: $(JUDGE)
// URL: $(URL)
// Memory Limit: $(MEMLIM)
// Time Limit: $(TIMELIM)
// Received: $(DATE)

#include <bits/stdc++.h>
using namespace std;

using ll = long long;
using ld = long double;
using pii = pair<int, int>;
using pll = pair<ll, ll>;
using vi = vector<int>;
using vll = vector<ll>;

#define all(x) begin(x), end(x)
#define rall(x) rbegin(x), rend(x)
#define sz(x) (int)(x).size()

template <class T> void read(vector<T> &v) {
  for (auto &x : v)
    cin >> x;
}

template <class T> void print(const vector<T> &v) {
  for (int i = 0; i < sz(v); ++i) {
    if (i)
      cout << ' ';
    cout << v[i];
  }
  cout << '\n';
}

template <class M, class K> void freq_add(M &mp, const K &key) { ++mp[key]; }

template <class M, class K> void freq_del(M &mp, const K &key) {
  auto it = mp.find(key);
  if (it == mp.end())
    return;
  if (--(it->second) == 0)
    mp.erase(it);
}

template <class T> ll sumv(const vector<T> &v) {
  return accumulate(all(v), 0LL);
}

template <class T> int minv(const vector<T> &v) {
  assert(!v.empty());
  return (int)(min_element(all(v)) - v.begin());
}

template <class T> int maxv(const vector<T> &v) {
  assert(!v.empty());
  return (int)(max_element(all(v)) - v.begin());
}

#ifdef LOCAL
template <class T> void _debug(const T &x) { cerr << x; }

template <class A, class B> void _debug(const pair<A, B> &p) {
  cerr << '(';
  _debug(p.first);
  cerr << ", ";
  _debug(p.second);
  cerr << ')';
}

template <class T> void _debug(const vector<T> &v) {
  cerr << '[';
  for (int i = 0; i < sz(v); ++i) {
    if (i)
      cerr << ", ";
    _debug(v[i]);
  }
  cerr << ']';
}

void dbg_out() { cerr << '\n'; }

template <class Head, class... Tail>
void dbg_out(const Head &h, const Tail &...t) {
  _debug(h);
  if constexpr (sizeof...(t))
    cerr << " | ";
  dbg_out(t...);
}

#define dbg(...) cerr << "[" << #__VA_ARGS__ << "] = ", dbg_out(__VA_ARGS__)
#else
#define dbg(...)
#endif

void solve() {}

int main() {
  ios::sync_with_stdio(false);
  cin.tie(nullptr);

  int T = 1;
  cin >> T;
  while (T--) {
    solve();
  }

  return 0;
}
