import 'package:rxdart/rxdart.dart';

typedef RxUseOnDone = void Function(
    Iterable elements, List<dynamic> onMapDatas);
typedef RxUseLinstener = void Function(dynamic result);
typedef RxUseWhere = bool Function(dynamic event);
typedef RxUseMap = dynamic Function(dynamic value);

abstract class RxUse {
  /*
  * 条件过滤
  * 默认where为null，外部传入一个function，来决定哪些数据需要被过滤
  * 默认linstener为null，外部可以获取到每次过滤后满足条件的结果
  * 默认onDone为null，外部可以获取到通过where条件过滤后的最终结果
  * */
  static where(Iterable elements,
      {RxUseWhere where = null,
      RxUseLinstener linstener = null,
      RxUseOnDone onDone = null}) {
    List onMapDatas = null;
    if (onDone != null) {
      onMapDatas = List();
    }
    Observable(Stream.fromIterable(elements)).where((event) {
      if (where != null) {
        return where(event);
      }
      return true;
    }).listen((onData) {
      if (onMapDatas != null) {
        onMapDatas..add(onData);
      }
      if (linstener != null) {
        linstener(onData);
      }
    }).onDone(() {
      if (onDone != null) {
        onDone(elements, onMapDatas);
      }
    });
  }

  /*
  * 跳过[0, skip]次的数据
  * 默认linstener为null，外部可以获取到从skip+1次开始的数据
  * 默认onDone为null，外部可以获取到[skip+1, elements.length-skip]的所有数据
  * */
  static skip(Iterable elements,
      {int skip = 0,
      RxUseLinstener linstener = null,
      RxUseOnDone onDone = null}) {
    List onMapDatas = null;
    if (onDone != null) {
      onMapDatas = List();
    }
    Observable(Stream.fromIterable(elements)).skip(skip).listen((onData) {
      if (onMapDatas != null) {
        onMapDatas..add(onData);
      }
      if (linstener != null) {
        linstener(onData);
      }
    }).onDone(() {
      if (onDone != null) {
        onDone(elements, onMapDatas);
      }
    });
  }

  /*
  * 过滤重复数据
  * 默认onDone为null，外部可以获取到过滤后的数据
  * */
  static distinctUnique(Iterable elements, {RxUseOnDone onDone = null}) {
    List onMapDatas = null;
    if (onDone != null) {
      onMapDatas = List();
    }
    Observable(Stream.fromIterable(elements)).distinctUnique().listen((onData) {
      if (onMapDatas != null) {
        onMapDatas..add(onData);
      }
    }).onDone(() {
      if (onDone != null) {
        onDone(elements, onMapDatas);
      }
    });
  }

  /*
  * 数据映射
  * 默认map为null，用于外部映射每个数据的结果
  * 默认onDone为null，外部可以获取映射后的结果
  * */
  static map(Iterable elements,
      {RxUseMap map = null, RxUseOnDone onDone = null}) {
    List onMapDatas = null;
    if (onDone != null) {
      onMapDatas = List();
    }
    Observable(Stream.fromIterable(elements)).map((value) {
      if (map != null) {
        return map(value);
      }
      return value;
    }).listen((onData) {
      if (onMapDatas != null) {
        onMapDatas..add(onData);
      }
    }).onDone(() {
      if (onDone != null) {
        onDone(elements, onMapDatas);
      }
    });
  }

  /*
  * 合并两组Future信号成为一组二维数组信号结果集返回，并且如果Future返回一个error，则onDone返回一个空数组
  * 默认linstener为null，返回每次获取到的信号
  * 默认onDone为null，外部可以获取映射后的结果
  * */
  static zip(Iterable<Future> futures,
      {RxUseLinstener linstener = null, RxUseOnDone onDone = null}) {
    List<Stream> streams = List();
    for (Future future in futures) {
      streams..add(Stream.fromFuture(future));
    }
    List onMapDatas = null;
    if (onDone != null) {
      onMapDatas = List();
    }
    Observable.zip(streams, (value) {
      return value;
    }).listen((onData) {
      if (onMapDatas != null) {
        onMapDatas..add(onData);
      }
      if (linstener != null) {
        linstener(onData);
      }
    }).onDone(() {
      if (onDone != null) {
        onDone(streams, onMapDatas);
      }
    });
  }

  /*
  * 合并多个Future信号，最终结果只会返回成功的内容
  * 默认onDone为null，外部可以获取映射后的结果
  * */
  static merges(Iterable<Future> futures, {RxUseOnDone onDone = null}) {
    List<Stream> streams = List();
    for (Future future in futures) {
      streams..add(Stream.fromFuture(future));
    }
    List onMapDatas = null;
    if (onDone != null) {
      onMapDatas = List();
    }
    Observable.merge(streams).listen((onData) {
      if (onMapDatas != null) {
        onMapDatas..add(onData);
      }
    }).onDone(() {
      if (onDone != null) {
        onDone(streams, onMapDatas);
      }
    });
  }

  /*
  * 将Future包装成Observable信号抛出去
  * */
  static Observable observable(Future future) {
    return Observable(Stream.fromFuture(future));
  }
}

abstract class RxMethods {
  
  static Observable delay(Stream stream, {int milliseconds = 0}) {
    return Observable(stream).delay(Duration(milliseconds: milliseconds));
  }
}