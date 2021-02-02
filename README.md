# Atomic 理解

> atomic是指一个事物的操作是不可分割的，要么发生，要么不发生

#### 举个例子: 银行转账业务

* 转账流程: 用户 -> 银行 -> 扣款 -> 失败就返回钱款

### 那么回到OC中:

atomic和nonatomic, 理解为线程安全和非线程安全

因为atomic描述的是属性赋值, 属性赋值还有很多其他操作，如访问对象，赋值等等，atomic是保证这个赋值的整个过程的完整性，并且不受其他线程的干扰，要么成功要么失败。

### 看个问题: 为什么atomic有时候无法保证线程安全

*个人结论*:用atomic修饰后，这个属性的setter, getter方法是线程安全的，但对于整个对象来说不一定是线程安全的。

#### 1.为什么setter、getter方法是线程安全的？

因为在setter和getter赋值取值的时候添加了自旋锁

```c
// getter
id objc_getProperty(id self, SEL _cmd, ptrdiff_t offset, BOOL atomic) {
  // ...
  if (!atomic) return *slot;
  
  //Atomic retain release world
  spinlock_t& slotlock = PropertyLocks[slot];
  slotlock.lock();
  id value = objc_retain(*slot);
  slotlock.unlock();
  // ...
}

// setter
static inline void reallySetProperty(id self, SEL _cmd, id newValue, ptrdiff_t offset,, bool atomic, bool copy, bool mutableCopy) {
  // ...
   if (!atomic) {
       oldValue = *slot;
       *slot = newValue;
   } else {
       spinlock_t& slotlock = PropertyLocks[slot];
       slotlock.lock();
       oldValue = *slot;
       *slot = newValue;        
       slotlock.unlock();
   }
   // ...
}
```

#### 为什么说atomic没办法保证整个对象的线程安全

>1.对于NSArray类型 `@property(atomic)NSArray *array`我们用atomic修饰，数组的添加和删除并不是线程安全的，这是因为数组比较特殊，我们要分成两部分考虑，一部分是&array也就是这个数组本身，另一部分是他所指向的内存部分。atomic限制的只是&array部分，对于它指向的对象没有任何限制。 atomic表示，我TM也很冤啊！！！！



>2.当线程A进行写操作，这时其他线程的读或者写操作会因为该操作而等待。当A线程的写操作结束后，B线程进行写操作，然后当A线程需要读操作时，却获得了在B线程中的值，这就破坏了线程安全，如果有线程C在A线程读操作前release了该属性，那么还会导致程序崩溃。所以仅仅使用atomic并不会使得线程安全，我们还要为线程添加lock来确保线程的安全。 个人觉得这个就有点杠精的意味了，atomic还要管到你方法外面去了？？？？？不过面试人家问你还要这么答，要严谨！！，