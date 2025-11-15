# Performance Monitoring Rules
# Aturan Pemantauan Kinerja

---

## 📋 **Document Metadata**

| Field | Value |
|-------|-------|
| **Document ID** | RULES-PERFORMANCE-MONITORING |
| **Version** | 1.0 |
| **Status** | Active |
| **Category** | Performance Rules |
| **Priority** | High |
| **Created Date** | November 15, 2025 |
| **Last Updated** | November 15, 2025 |
| **Next Review** | November 22, 2025 |
| **Author** | Mobile Development Team |
| **Reviewers** | Performance Team, Tech Lead |
| **Stakeholders** | Development Team, QA Team, DevOps Team |

---

## 🎯 **Purpose**

Dokumen ini mendefinisikan aturan dan pedoman performance monitoring yang wajib diikuti dalam pengembangan aplikasi Usago Mobile. Aturan ini berdasarkan implementasi performance monitoring yang ada di [`../docs/06-operations/performance-monitoring.md`](../docs/06-operations/performance-monitoring.md).

---

## 📚 **Table of Contents**

1. [BLoC Performance Rules](#bloc-performance-rules)
2. [Memory Management Rules](#memory-management-rules)
3. [API Performance Rules](#api-performance-rules)
4. [UI Performance Rules](#ui-performance-rules)
5. [Performance Thresholds](#performance-thresholds)
6. [Monitoring Setup Rules](#monitoring-setup-rules)
7. [Performance Optimization Rules](#performance-optimization-rules)
8. [Performance Reporting Rules](#performance-reporting-rules)

---

## 🎭 **BLoC Performance Rules**

### **Rule 1.1: BLoC Event Execution Time**

BLoC event execution WAJIB kurang dari 500ms:

```dart
// ✅ BENAR: Fast BLoC event handling
class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    await executeUseCase(
      _loginUseCase.call,
      LoginParams(email: event.email, password: event.password),
      eventName: 'Login',
      metadata: {'email': event.email},
    );
  }
}

// ❌ SALAH: Slow BLoC event handling
class SlowAuthBloc extends BaseBloc<AuthEvent, AuthState> {
  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    // Heavy computation tanpa tracking
    await _heavyComputation();
    await _networkCall();
    await _dataProcessing();
    emit(AuthSuccess());
  }
}
```

### **Rule 1.2: BLoC State History Management**

BLoC state history WAJIB dibatasi maksimal 100 states:

```dart
// ✅ BENAR: Limited state history
class BaseBloc<Event extends BaseEvent, State extends BaseState> extends Bloc<Event, State> {
  static const int maxStateHistory = 100;
  final List<State> _stateHistory = [];

  void _addToStateHistory(State state) {
    _stateHistory.add(state);
    if (_stateHistory.length > maxStateHistory) {
      _stateHistory.removeAt(0);
    }
  }
}

// ❌ SALAH: Unbounded state history
class UnboundedBloc extends Bloc<Event, State> {
  final List<State> _stateHistory = []; // Bisa memory leak!

  void _addToStateHistory(State state) {
    _stateHistory.add(state); // Tidak ada batasan!
  }
}
```

### **Rule 1.3: BLoC Event Queue Management**

BLoC event queue WAJIB dibatasi maksimal 50 events:

```dart
// ✅ BENAR: Event queue management
class BaseBloc<Event extends BaseEvent, State extends BaseState> extends Bloc<Event, State> {
  static const int maxEventQueueSize = 50;
  final Queue<Event> _eventQueue = Queue();

  void _addToEventQueue(Event event) {
    if (_eventQueue.length >= maxEventQueueSize) {
      _eventQueue.removeFirst();
    }
    _eventQueue.add(event);
  }
}
```

---

## 🧠 **Memory Management Rules**

### **Rule 2.1: Memory Usage Thresholds**

Memory usage WAJIB dipantau dan di-alert saat > 80%:

```dart
// ✅ BENAR: Memory monitoring dengan thresholds
class MemoryManager {
  static const double memoryWarningThreshold = 0.8;
  static const double memoryCriticalThreshold = 0.9;

  void _checkMemoryThresholds(MemorySnapshot snapshot) {
    if (snapshot.memoryUsagePercentage >= memoryCriticalThreshold) {
      _handleCriticalMemoryUsage(snapshot);
    } else if (snapshot.memoryUsagePercentage >= memoryWarningThreshold) {
      _handleWarningMemoryUsage(snapshot);
    }
  }
}

// ❌ SALAH: Tidak ada memory monitoring
class NoMemoryManager {
  void processData() {
    // Tidak ada monitoring memory usage
    final largeData = List.generate(1000000, (index) => index);
    // Bisa menyebabkan OOM
  }
}
```

### **Rule 2.2: Automatic Memory Cleanup**

Automatic cleanup WAJIB diimplementasikan saat memory usage tinggi:

```dart
// ✅ BENAR: Automatic memory cleanup
class MemoryManager {
  void _handleCriticalMemoryUsage(MemorySnapshot snapshot) {
    _performMemoryCleanup();
  }

  void _performMemoryCleanup() {
    _clearBlocCaches();
    _clearImageCaches();
    _forceGarbageCollection();
  }
}

// ❌ SALAH: Tidak ada cleanup mechanism
class LeakyMemoryManager {
  void handleMemoryUsage() {
    // Tidak ada action saat memory tinggi
    print('Memory usage is high'); // Hanya log tanpa action
  }
}
```

### **Rule 2.3: Image Cache Management**

Image cache WAJIB dibatasi maksimal 100 images:

```dart
// ✅ BENAR: Limited image cache
class ImageCacheManager {
  static const int maxCacheSize = 100;
  final Map<String, ui.Image> _cache = {};

  void cacheImage(String url, ui.Image image) {
    if (_cache.length >= maxCacheSize) {
      _clearOldestImages();
    }
    _cache[url] = image;
  }

  void _clearOldestImages() {
    final keys = _cache.keys.toList();
    final keysToRemove = keys.take(20);
    for (final key in keysToRemove) {
      _cache.remove(key);
    }
  }
}

// ❌ SALAH: Unbounded image cache
class UnboundedImageCache {
  final Map<String, ui.Image> _cache = {};

  void cacheImage(String url, ui.Image image) {
    _cache[url] = image; // Memory leak!
  }
}
```

---

## 🌐 **API Performance Rules**

### **Rule 3.1: API Response Time**

API response time WAJIB kurang dari 5 detik:

```dart
// ✅ BENAR: API performance tracking
class ApiClient {
  Future<Response> makeRequest(String endpoint, Map<String, dynamic> data) async {
    final stopwatch = Stopwatch()..start();

    try {
      final response = await _dio.post(endpoint, data: data);
      stopwatch.stop();

      _trackApiPerformance(endpoint, stopwatch.elapsed, true);
      return response;
    } catch (e) {
      stopwatch.stop();
      _trackApiPerformance(endpoint, stopwatch.elapsed, false, error: e.toString());
      rethrow;
    }
  }

  void _trackApiPerformance(String endpoint, Duration duration, bool success, {String? error}) {
    if (duration.inSeconds > 5) {
      _sendPerformanceAlert('Slow API: $endpoint took ${duration.inSeconds}s');
    }
  }
}

// ❌ SALAH: Tidak ada performance tracking
class UntrackedApiClient {
  Future<Response> makeRequest(String endpoint, Map<String, dynamic> data) async {
    // Tidak ada tracking
    return await _dio.post(endpoint, data: data);
  }
}
```

### **Rule 3.2: Request Retry dengan Exponential Backoff**

Failed requests WAJIB di-retry dengan exponential backoff:

```dart
// ✅ BENAR: Exponential backoff retry
class RetryManager {
  static Future<Either<Failure, T>> retryWithBackoff<T>(
    Future<Either<Failure, T>> Function() operation, {
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 1),
  }) async {
    var delay = initialDelay;

    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      final result = await operation();

      if (result.isRight()) {
        return result;
      }

      if (attempt < maxRetries) {
        await Future.delayed(delay);
        delay = Duration(milliseconds: delay.inMilliseconds * 2);
      }
    }

    return const Left(ServerFailure(message: 'Max retries exceeded'));
  }
}

// ❌ SALAH: Tidak ada retry mechanism
class NoRetryClient {
  Future<Response> makeRequest(String endpoint) async {
    try {
      return await _dio.get(endpoint);
    } catch (e) {
      // Langsung gagal tanpa retry
      rethrow;
    }
  }
}
```

### **Rule 3.3: Concurrent Request Limiting**

Concurrent requests WAJIB dibatasi maksimal 5:

```dart
// ✅ BENAR: Concurrent request limiting
class ConcurrencyLimiter {
  static const int maxConcurrentRequests = 5;
  int _activeRequests = 0;
  final Queue<Completer> _queue = Queue();

  Future<T> execute<T>(Future<T> Function() operation) async {
    if (_activeRequests >= maxConcurrentRequests) {
      final completer = Completer<T>();
      _queue.add(completer);
      await completer.future;
    }

    _activeRequests++;
    try {
      return await operation();
    } finally {
      _activeRequests--;
      _processQueue();
    }
  }
}

// ❌ SALAH: Tidak ada concurrency limiting
class UnconcurrentClient {
  Future<Response> makeRequest(String endpoint) async {
    // Banyak concurrent requests tanpa batasan
    return await _dio.get(endpoint);
  }
}
```

---

## 🎨 **UI Performance Rules**

### **Rule 4.1: Frame Rate Maintenance**

Frame rate WAJIB dipertahankan minimal 30 FPS:

```dart
// ✅ BENAR: Frame rate monitoring
class FrameRateMonitor {
  Duration _lastFrameTime = Duration.zero;
  int _frameCount = 0;

  void recordFrame() {
    final now = DateTime.now();
    final frameTime = now.difference(_lastFrameTime);
    _lastFrameTime = now;

    _frameCount++;

    if (_frameCount % 60 == 0) {
      final fps = 1000 / frameTime.inMilliseconds;
      if (fps < 30) {
        _sendPerformanceAlert('Low FPS detected: ${fps.toStringAsFixed(1)}');
      }
    }
  }
}

// ❌ SALAH: Tidak ada frame rate monitoring
class UnmonitoredWidget extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    // Complex animation tanpa monitoring
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: child,
        );
      },
    );
  }
}
```

### **Rule 4.2: Widget Rebuild Optimization**

Widget rebuilds WAJIB dioptimasi dengan const constructors:

```dart
// ✅ BENAR: Optimized widget rebuilds
class OptimizedWidget extends StatelessWidget {
  final String title;

  const OptimizedWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text('Static Text'), // const widget
        Icon(Icons.star),    // const widget
      ],
    );
  }
}

// ❌ SALAH: Unnecessary widget rebuilds
class UnoptimizedWidget extends StatelessWidget {
  final String title;

  UnoptimizedWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Static Text'), // Rebuild setiap kali
        Icon(Icons.star),    // Rebuild setiap kali
      ],
    );
  }
}
```

### **Rule 4.3: Image Loading Optimization**

Image loading WAJIB dioptimasi dengan lazy loading:

```dart
// ✅ BENAR: Optimized image loading
class OptimizedImageList extends StatelessWidget {
  final List<String> imageUrls;

  const OptimizedImageList({Key? key, required this.imageUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        return CachedNetworkImage(
          imageUrl: imageUrls[index],
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          memCacheWidth: 300, // Limit cache size
        );
      },
    );
  }
}

// ❌ SALAH: Unoptimized image loading
class UnoptimizedImageList extends StatelessWidget {
  final List<String> imageUrls;

  UnoptimizedImageList({Key? key, required this.imageUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: imageUrls.map((url) {
        return Image.network(url); // Load semua images sekaligus
      }).toList(),
    );
  }
}
```

---

## 📊 **Performance Thresholds**

### **Rule 5.1: BLoC Performance Thresholds**

- **Warning**: BLoC execution > 200ms
- **Critical**: BLoC execution > 500ms
- **Maximum**: BLoC execution > 1000ms

```dart
class PerformanceConstants {
  static const Duration blocWarningThreshold = Duration(milliseconds: 200);
  static const Duration blocCriticalThreshold = Duration(milliseconds: 500);
  static const Duration blocMaximumThreshold = Duration(milliseconds: 1000);
}
```

### **Rule 5.2: Memory Performance Thresholds**

- **Warning**: Memory usage > 70%
- **Critical**: Memory usage > 85%
- **Maximum**: Memory usage > 95%

```dart
class PerformanceConstants {
  static const double memoryWarningThreshold = 0.7;
  static const double memoryCriticalThreshold = 0.85;
  static const double memoryMaximumThreshold = 0.95;
}
```

### **Rule 5.3: API Performance Thresholds**

- **Warning**: API response > 2 detik
- **Critical**: API response > 5 detik
- **Timeout**: API response > 30 detik

```dart
class PerformanceConstants {
  static const Duration apiWarningThreshold = Duration(seconds: 2);
  static const Duration apiCriticalThreshold = Duration(seconds: 5);
  static const Duration apiTimeoutThreshold = Duration(seconds: 30);
}
```

---

## 🔧 **Monitoring Setup Rules**

### **Rule 6.1: Performance Monitoring Initialization**

Performance monitoring WAJIB diinitialize di main.dart:

```dart
// ✅ BENAR: Performance monitoring initialization
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load configuration
  await EnvConfig.load();

  // Initialize performance monitoring
  if (AppConfig.enablePerformanceMonitoring) {
    PerformanceTracker().initialize();
    MemoryManager().startMonitoring();
    PerformanceAlertManager().initialize();
  }

  runApp(const MyApp());
}

// ❌ SALAH: Tidak ada performance monitoring
void main() {
  runApp(const MyApp()); // Tidak ada monitoring
}
```

### **Rule 6.2: Performance Tracking Configuration**

Performance tracking WAJIB dikonfigurasi per environment:

```dart
// ✅ BENAR: Environment-specific configuration
class PerformanceConfig {
  static bool get shouldEnablePerformanceMonitoring {
    switch (EnvConfig.currentEnvironment) {
      case Environment.development:
        return true;
      case Environment.staging:
        return true;
      case Environment.production:
        return false; // Disabled in production
    }
  }

  static Duration get monitoringInterval {
    switch (EnvConfig.currentEnvironment) {
      case Environment.development:
        return const Duration(seconds: 5);
      case Environment.staging:
        return const Duration(seconds: 10);
      case Environment.production:
        return const Duration(seconds: 30);
    }
  }
}
```

### **Rule 6.3: Performance Alert Configuration**

Performance alerts WAJIB dikonfigurasi dengan thresholds:

```dart
// ✅ BENAR: Alert configuration
class PerformanceAlertConfig {
  static const List<AlertRule> alertRules = [
    AlertRule(
      metric: 'bloc_execution_time',
      threshold: Duration(milliseconds: 500),
      level: AlertLevel.critical,
    ),
    AlertRule(
      metric: 'memory_usage',
      threshold: 0.85,
      level: AlertLevel.critical,
    ),
    AlertRule(
      metric: 'api_response_time',
      threshold: Duration(seconds: 5),
      level: AlertLevel.critical,
    ),
  ];
}
```

---

## ⚡ **Performance Optimization Rules**

### **Rule 7.1: Automatic Performance Optimization**

System WAJIB melakukan optimasi otomatis saat performance issues terdeteksi:

```dart
// ✅ BENAR: Automatic optimization
class PerformanceOptimizer {
  void optimizeBasedOnMetrics(PerformanceMetric metric) {
    switch (metric.category) {
      case 'bloc':
        if (metric.duration.inMilliseconds > 200) {
          _optimizeBlocPerformance();
        }
        break;
      case 'memory':
        if (metric.memoryUsage > 0.8) {
          _optimizeMemoryUsage();
        }
        break;
      case 'api':
        if (metric.duration.inSeconds > 2) {
          _optimizeApiPerformance();
        }
        break;
    }
  }
}

// ❌ SALAH: Tidak ada optimasi otomatis
class NoOptimizationManager {
  void handlePerformanceIssue(PerformanceMetric metric) {
    // Tidak ada action
    print('Performance issue detected: ${metric.name}');
  }
}
```

### **Rule 7.2: Caching Strategy Implementation**

Caching WAJIB diimplementasikan untuk performance improvement:

```dart
// ✅ BENAR: Caching implementation
class PerformanceCache {
  final Map<String, CachedItem> _cache = {};
  static const Duration defaultCacheExpiry = Duration(hours: 1);

  Future<T?> get<T>(String key) async {
    final item = _cache[key];
    if (item == null || item.isExpired) {
      _cache.remove(key);
      return null;
    }
    return item.data as T?;
  }

  Future<void> set<T>(String key, T data, {Duration? expiry}) async {
    final item = CachedItem(
      data: data,
      timestamp: DateTime.now(),
      expiry: expiry ?? defaultCacheExpiry,
    );
    _cache[key] = item;
  }
}

// ❌ SALAH: Tidak ada caching
class NoCacheService {
  Future<Data> fetchData(String key) async {
    // Selalu fetch dari API tanpa cache
    return await _apiService.getData(key);
  }
}
```

### **Rule 7.3: Lazy Loading Implementation**

Lazy loading WAJIB diimplementasikan untuk large datasets:

```dart
// ✅ BENAR: Lazy loading implementation
class LazyLoadingList extends StatefulWidget {
  final Future<List<Item>> Function(int page) fetchItems;

  const LazyLoadingList({Key? key, required this.fetchItems}) : super(key: key);

  @override
  _LazyLoadingListState createState() => _LazyLoadingListState();
}

class _LazyLoadingListState extends State<LazyLoadingList> {
  final ScrollController _scrollController = ScrollController();
  final List<Item> _items = [];
  bool _isLoading = false;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadMoreItems();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final newItems = await widget.fetchItems(_currentPage);
      setState(() {
        _items.addAll(newItems);
        _currentPage++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }
}

// ❌ SALAH: Load semua data sekaligus
class EagerLoadingList extends StatelessWidget {
  final Future<List<Item>> itemsFuture;

  const EagerLoadingList({Key? key, required this.itemsFuture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Item>>(
      future: itemsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ItemWidget(item: snapshot.data![index]);
            },
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
```

---

## 📈 **Performance Reporting Rules**

### **Rule 8.1: Daily Performance Reports**

Performance reports WAJIB di-generate setiap hari:

```dart
// ✅ BENAR: Daily performance reports
class PerformanceReporter {
  Future<void> generateDailyReport() async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    final metrics = await _getMetricsForDate(yesterday);
    final report = PerformanceReport(
      date: yesterday,
      metrics: metrics,
      summary: _generateSummary(metrics),
    );

    await _saveReport(report);
    await _sendReportToStakeholders(report);
  }
}

// ❌ SALAH: Tidak ada performance reporting
class NoPerformanceReporter {
  void handleMetrics() {
    // Tidak ada reporting
  }
}
```

### **Rule 8.2: Performance Alert Notifications**

Performance alerts WAJIB dikirim ke stakeholders:

```dart
// ✅ BENAR: Alert notifications
class PerformanceAlertManager {
  Future<void> sendCriticalAlert(PerformanceAlert alert) async {
    await _notifyDevelopmentTeam(alert);
    await _notifyDevOpsTeam(alert);
    await _logAlert(alert);
  }

  Future<void> sendWarningAlert(PerformanceAlert alert) async {
    await _notifyDevelopmentTeam(alert);
    await _logAlert(alert);
  }
}

// ❌ SALAH: Tidak ada alert notifications
class SilentAlertManager {
  void handleAlert(PerformanceAlert alert) {
    // Tidak ada notifikasi
    print('Alert: ${alert.message}');
  }
}
```

### **Rule 8.3: Performance Dashboard**

Performance dashboard WAJIB tersedia untuk monitoring real-time:

```dart
// ✅ BENAR: Performance dashboard
class PerformanceDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            MemoryUsageChart(),
            BlocPerformanceChart(),
            ApiPerformanceChart(),
            PerformanceAlertsList(),
          ],
        ),
      ),
    );
  }
}

// ❌ SALAH: Tidak ada dashboard
class NoDashboard {
  void showPerformance() {
    // Tidak ada visualisasi
  }
}
```

---

## ✅ **Performance Checklist**

### **Development Phase**
- [ ] Performance monitoring diinitialize
- [ ] BLoC performance tracking aktif
- [ ] Memory monitoring aktif
- [ ] API performance tracking aktif
- [ ] UI performance monitoring aktif

### **Testing Phase**
- [ ] Performance tests untuk BLoC
- [ ] Memory usage tests
- [ ] API performance tests
- [ ] UI performance tests
- [ ] Load testing

### **Deployment Phase**
- [ ] Performance thresholds terkonfigurasi
- [ ] Performance alerts aktif
- [ ] Performance dashboard tersedia
- [ ] Performance reporting terjadwal
- [ ] Performance monitoring di production

---

## 🔗 **Related Documentation**

- [`../docs/06-operations/performance-monitoring.md`](../docs/06-operations/performance-monitoring.md) - Complete performance monitoring guide
- [`../lib/core/constants/performance_constants.dart`](../lib/core/constants/performance_constants.dart) - Performance constants
- [`../lib/core/performance/performance_tracker.dart`](../lib/core/performance/performance_tracker.dart) - Performance tracker implementation
- [`../lib/core/performance/memory_manager.dart`](../lib/core/performance/memory_manager.dart) - Memory manager implementation

---

## 📞 **Contact Information**

### **Performance Team**

| Issue | Contact | Response Time |
|-------|----------|---------------|
| **Performance Issue** | performance@usago.id | 2 hours |
| **Memory Leak** | performance@usago.id | 1 hour |
| **Optimization Request** | performance@usago.id | 4 hours |

---

## 📝 **Notes**

### **Performance Targets**
- BLoC execution time < 200ms (average)
- Memory usage < 70% (average)
- API response time < 2s (average)
- Frame rate > 30 FPS
- App startup time < 3s

### **Monitoring Tools**
- Performance tracking system
- Memory monitoring tools
- API performance monitoring
- UI performance profiling
- Crash reporting system

---

**Document End**

**Go Digital, Grow Together.**