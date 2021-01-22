// Hello World App!
import std.stdio : writeln;

/// typesBasics shows the primitive types of D and their attributes
void typesBasics() @trusted
{
	writeln("\nType Basics in D...");
	// Big numbers can be separated
	// with an underscore "_"
	// to enhance readability
	const int b = 7_000_000;
	const short c = cast(short) b; // always need to cast in D if bit-precision is LOST
	const uint d = b; // uint -> int ok since same width 
	const int g;
	assert(g == 0); // all types have .init property 			 // so int numeric types are -> 0
	const auto f = 3.14159f; // same auto system as C++

	// typeid(VAR) returns the type information
	// of an expression
	writeln("type of f is: ", typeid(f));
	const double pi = f; // this is fine because precision is GAINED
	// for floating-port types
	// implicit down-casting is allowed (why?)
	const float demoted = pi;
	assert(float(pi) == demoted);

	// access to type properties
	assert(int.init == 0); // yes
	assert(int.sizeof == 4); // maybe 
	assert(bool.max == 1); // yes
	writeln(int.min, " ", int.max);
	writeln(int.stringof); // int
}

/// memory shows basic memory management in Dlang
void memory() @trusted
{
	writeln("\nMemory Basics in D...");
	// D allows for manual memory management
	// but uses a garbage collector by default

	// pointer types are provided
	int a;
	int* b = &a; // pointer = addressof(a)
	auto c = &a;	 // probably the best way
	writeln("a: ", a, ", b = &a = ", b);

	// heap memory can be allocated using "new"
	// as soon as the memory referenced by A isn't 
	// referenced anyore at any point in the program
	// the garbage collector can free its memory
	int* A = new int;

	// SAFETY LEVELS
	// 	@safe 		:	can only call @safe or @trusted functions, pointer arithmetic forbidden too
	//	@trusted 	: 	manually verfied functions that allow a bridge between SafeD and low-level code
	//	@system 	:	default, no additional
	safeFun();
	unSafeFun();
}

/// shows @safe attribute
void safeFun() @safe
{
	writeln("@safe functions can allocate mem with GC, no pointer arithmetic");
	int* p = new int;
	writeln("int* p = ", p);
}

/// shows @system attribute
void unSafeFun()
{
	writeln("@system functions can allocate mem with GC, can do pointer arithmetic");
	int* p = new int;
	writeln("int* p = ", p);
	int* pArith = p + 5;
	writeln("int* p+5 = ", pArith);
}

/// mutability shows different mutability type qualifier
void mutability(const string s)
{
	writeln("\nMutability Basics in D...");
	// immutable objects can only be initialized once and after cannot change
	// are thread safe without syncronization because they cannot change (duh) 
	immutable int im = 6;

	// const objects also can't be modified, but this is only within the declaring scope
	// so, a const object is unmodifiedable in a current scope, but could be modified
	// from a different context
	// for example, const arguments to functions are const within the functions,
	// but could be modifed elsewhree
	const int con = 6;
	writeln("Printing const-passed char[]: ", s);
}

/// controlFlow shows basic control flow (conditionals) available in D
void controlFlow() 
{
	writeln("\nControl Flow Basics in D...");
	// use boolean operators:
	// ==, !=, <, >, <=, >=
	// use logical operators to combine boolean expressions
	// ||, &&
	int a = 5;
	if (a == 5)
	{
		writeln("a == 5");
		a = 6;
	}
	else if (a < 1)
	{
		writeln("a < 1");
	}
	else
	{
		a = 7;
	}
}


/// functions details some unique things about functions in D
void functions()
{
	writeln("\nFunctions Basics in D...");
	// functions can have an auto return
	// which is inferred by the compiler
	const auto a = autoReturnAdd(1, 2); // provide arguments
	const int check = autoReturnAdd(); // use default arguments
	static assert(typeid(a) == typeid(check)); // verify auto return is "int"

	if (check == 0)
	{
		writeln("Default arguments of autoReturnAdd are (0,0)");
	}

	// functions can be delcared inside functions
	// this goes with the "turtles all the way down"
	// approach that D takes where all rules seem 
	// to apply at any aribtrary scope or context

	// local functions are called "delegates" in D
	int localFunc() 
	{
		const int local = 10;
		return local + 1;
	}
	const int localResult = localFunc();
}

/// autoReturn demonstrates the auto return type inference in D
/// also provides default arguments
auto autoReturnAdd(int lhs = 0, int rhs = 0) @safe
{
	return lhs + rhs;
}

/// person is a basic struct with fields describing a person
struct Person 
{
	/// exclusive constructor for this struct
	/// axeXHeight is calculated
	this(const int age, const int height)
	{
		this.age = age;
		this.height = height;
		this.ageXHeight = cast(float)age * height;
	}

	/// implements a simple "getter" for this class 
	float getProd()
	{
		return ageXHeight;
	}

	/// static member function example to show how static functions can
	/// be called without an existing instance
	static void printDesc()
	{
		writeln("This is a static member function of the struct, Person.  This can be called without an instantiated object of the Person struct.");
	}

	// fields are default "public", but can be made "private"
	/// age in years
	private uint age = 0; // provide default initializer
	/// height in cm 	
	private uint height = 0;
	/// product of age and height
	private float ageXHeight = 0.0f;
}

/// structs shows off how to use and initialize structs 
/// along with  the example struct, Person above
void structs()
{
	writeln("\nStructs Basics in D...");

	Person.printDesc();

	// construct a struct using the defined constructor
	auto p = Person(30, 190); // initialization
	const auto t = p; // structs are copy-able

	p = Person(20, 80); // re-assignment
	writeln("Printing struct: ", p);

	writeln("Age * Height = ", p.getProd());

	// it is interesting to note that in D,
	// structs cannot use inheritance.  Only
	// classes have that capability
}

/// classic Vector3 struct
struct Vector3
{
	/// 
	this(const float x, const float y, const float z)
	{
		this.x = x;
		this.y = y;
		this.z = z;
	}

	/// dot this vector with another one 
	float dot(const Vector3 vec) const // can put const here just like C++
	{
		return (this.x * vec.x) + (this.y * vec.y) + (this.z * vec.z);
	}

	/// calculates length: sqrt((x*x) + (y*y) + (z*z)) 
	float length() const
	{
		import std.math : sqrt;
		// TODO: idk
		return sqrt((x*x) + (y*y) + (z*z));
	}

	/// return formatted string describing object
	string toString() const
	{
		import std.string : format;
		return format("Vector3:\n\tx = %f\n\ty = %f\n\tz = %f", this.x, this.y, this.z);
	}

	float x = 0.0f;
	float y = 0.0f;
	float z = 0.0f;
}

/// compute dot product of two vector3 objects
float dot(const Vector3 A, const Vector3 B)
{
	return (A.x * B.x) + (A.y * B.y) + (A.z * B.z);
}


/// simple test to verify that Vector3 class works
void vector3Test()
{
	writeln("\nBasic tests for Vector3 class...");
	const auto A = Vector3(3, 1, 3);
	const auto B = Vector3(3, 5, 0);

	const float dotMember = A.dot(B);
	const float dot = dot(A, B);
	assert(dot == dotMember);

	writeln(A.toString());
	writeln(B.toString());

	const auto lenA = A.length();
	const auto lenB = B.length();
	writeln("A is length: ", lenA, " and B is length: ", lenB);
}


/// arrays shows the basics of arrays in D
void arrays()
{
	writeln("\nArrays Basics in D...");
	// There are four kinds of arrays in D:
	//		T*		:		pointer to data
	//		T[int]	:		static array	
	//		T[]		:		dynamic array
	//		T[T]	:		associative arrays

	// Pointers (T*)
	// 		a pointer to a type, T has a value which is a 
	//		reference (address) to another object of type T
	
	// Static Arrays (T[int])
	//		static arrays have a fixed length at compile time
	// 		total size cannot exceed 16MB
	//		static arrays with dimension of 0 are allowed, but no space is allcoated
	// 		static arrays are "value types," meaning they are passed to and returned by functions by value

	// Dynamic Arrays (T[])
	//		dynamic arrays consist of a length and a pointer to the array data
	//		multiple dynamic arrays can share all or parts of the array data (slices concept)
	//		dynamic arrays differ from pointer to arrays because the yare bounds checked
	//		

	// Associative Arrays T[T]
	//		int[string] arr; 
	// 		is an associative array (HASH MAP)
	//			with a key of type string
	//			and a value of type int


	// More on Slices
	auto arr = new int[5];
	assert(arr.length == 5);

	auto newArr = arr[1..4];	// index 4 NOT included
	assert(newArr.length == 3);
	newArr[0] = 10;

	// static arrays are stored on the stack if defined in a function
	// if in a global space, they are stored in the static memory portion
	int[8] staticArray;

	const int size = 8;
	int[] a = new int[size];
	a[0] = 0; a[1] = 1;
	a[2] = 2; a[3] = 3;
	a[4] = 4; a[5] = 5;
	a[6] = 6; a[7] = 7; 
	// int[] is a SLICE (just like in Go)
	// slices are views on a contiguous block of memory

	// mulit-dim arrays are easily created too
	auto multiArr = new int[size][size];

	// arrays can be concatenated using the ~ operator
	// mathematical operations can be applied ot whole arrays 
	// using a syntax like:
	//		c[] = a[] + b[]
	// where each operation is performed element-wise:
	//		c[0] = a[0] + b[0], c[1] = a[1] + b[1] ...
	writeln("a[] = ", a);
	//auto b = a[] * 2;
	//writeln("a[] * 2 = ", b);
	//auto c = a[] % 6;
	//writeln("a[] % 6 = ", c);

	// Associative Arrays are general hash maps
	int[string] assoc;
	assoc["key1"] = 1;
	assoc["key2"] = 2;

	if ("key1" in assoc)
	{
		writeln("Verified 'key1' in hash map...");
		writeln(assoc);
	}
	
	// in expression returns a pointer
	// if null, a conditional will be false, else true
	if (auto p = "key1" in assoc)
	{
		*p = 20;
		writeln("Verified 'key1' in hash map and wrote to the returned pointer...");
		writeln(assoc);
	}
}

/// look at how aliases work since strings are aliases of char arrays
/// also show some string manip properties, which are basically the same as
/// array manip in D
void aliasAndStrings()
{
	writeln("\nAlias and String Basics in D...");

	import std.conv : to;

	// aliases are like "using" directives in C++
	// makes sense, a string is an array of 8-bit Unicode units
	alias string = immutable(char)[]; 
	alias wstring = immutable(wchar)[];
	alias dstring = immutable(dchar)[];

	const string myString = "Hi";
	const dstring myDstring = to!dstring(myString);
	
	writeln("String is: ", myString);
	writeln("String type is: ", typeid(myString));
	writeln("Dstring is: ", myDstring);
	writeln("Dstring type is: ", typeid(myDstring));

	// since strings are just arrays, they have lengths
	string s = "this is a string";
	import std.range : walkLength;
	import std.uni : byGrapheme;

	writeln(s);
	writeln("length: ", s.length);
	writeln("walk length: ", s.walkLength);
	writeln("by Grapheme walk length: ", s.byGrapheme.walkLength);
	s = "\u0041\u0308"; // Ä
	writeln(s);
	writeln("length: ", s.length);
	writeln("walk length: ", s.walkLength);
	writeln("by Grapheme walk length: ", s.byGrapheme.walkLength);

	writeln("since strings are arrays of chars" ~ " we can use the array concat operator, ~");
}


/// loops shows.... loops
void loops()
{
	writeln("\nLoops Basics in D...");

	// we've got all the classics
	//		while
	//		do-while
	//		for
	// 		foreach

	const int condition = 4;
	int i = 0;

	void foo()
	{
		writeln("\tcalling foo");
	}

	writeln("while loop:");
	while (i < condition)
	{
		foo();
		++i;
	}

	i = 0; // reset
	writeln("do-while loop:");
	do
	{
		foo();
		++i;
	} 	while (i < condition);

	i = 0;
	writeln("for loop:");
	for(; i < condition; ++i)
	{
		foo();
	}
	
	int[] arr = [1, 2, 3, 4];
	writeln("foreach loop:");
	foreach(el; arr)
	{
		foo();
	} 

	writeln("Showing break with labels in D");
	outer: for (int k = 0; k < 10; ++k)
	{
		for (int j = 0; j < 5; ++j)
		{
			foo();
			break outer;
		}
	}

	double average(int[] array)
	{
		immutable initialLength = array.length;
		double accumulator = 0.0;
		
		while (array.length)
		{
			accumulator += array[0];
			array = array[1 .. $]; 
			// shorten the slice view onto the array
			// until the slice view size is 0
		}
		return accumulator / initialLength;
	}

	auto testers = [ [5, 15], // 20
          [2, 3, 2, 3], // 10
          [3, 6, 2, 9] ]; // 20

	for (auto t = 0; t < testers.length; ++t)
	{
		writeln("The average of ", testers[t], " = ", average(testers[t]));
	}


	// foreach
	//		5 ways to declare
	//		first 2 (type element; array)
	//				(element; array)
	//		take element by value (create a copy)
	//		(ref element; array)
	//		naturally takes a reference
	//		also, foreach(elem; 0 .. 3)
	//		also, foreach(index, elem; [])
	writeln("checking if foreach gets by value or ref...");
	writeln("original array: ", arr);
	foreach(int elem; arr)
	{
		elem = 10;
	}	
	writeln("foreach(int elem; arr) ", arr);

	foreach (elem; arr)
	{
		elem = 10;
	}
	writeln("foreach(elem; arr) ", arr);

	foreach (ref elem; arr)
	{
		elem = 10;
	}
	writeln("foreach(ref elem; arr) ", arr);

	writeln("foreach(elem; start .. end) ");
	foreach (elem; 0 .. 3)
	{
		writeln("\t", elem);
	}

	writeln("foreach(index, elem; []) ");
	foreach (index, elem; [1, 2, 3, 4])
	{
		writeln("\t", index, ", ", elem);
	}

	// foreach_reverse
	writeln("foreach_reverse (index, elem; []) ");
	foreach_reverse (index, elem; [1, 2, 3, 4])
	{
		writeln("\t", index, ", ", elem);
	}
}

/// ranges describes the "concept of ranges" in D
void ranges()
{
	import std.range : repeat, take, drop, iota, retro, 
		save, refRange;
	writeln("\nRanges Basics in D...");

	// if a foreach is encountered by the compiler
	// foreach (elem; range)
	// 	{
	//		body
	//	}

	// it is rewritten internally as:
	// for(auto rangeCopy = range;
	//		! rangeCopy.empty;
	//		__rangeCopy.popFront())
	// 	{
	//		auto element = __rangeCopy.front;
	//		body
	//	}

	// any object that fulfills the following interface is a range
	// interface InputRange(E)
	// 	{
	//		bool empty()
	//		E front();
	// 		void popFront();	
	//	}

	// note that ranges are LAZY
	//		they are evaluated only when values are acutally requested
	//		range form infinite ranges can be take ?????
	writeln("42.repeat.take(3).writeln");
	writeln("42.repeat is an infinite range, but we TAKE only 3");
	42.repeat.take(3).writeln;  // [42,42, 42]

	// 	if the range object is a value type
	// 	then it will be copied and only the copy is consumed
	writeln("Value Type Range:");
	auto r = 5.iota;
	r.drop(5).writeln; // []
	r.writeln; // [0, 1, 2, 3, 4, 5]

	//	if the range object is a reference type (like a class)
	//	then it will be consumed and wont be reset 
	writeln("Reference Type Range:");
	auto r2 = refRange(&r); // manually create a reference range
	r2.drop(5).writeln;
	r2.writeln;

	// Copyable InputRanges are ForwardRanges
	//	interface ForwardRange(E) : InputRange!E
	// 	{
	//		typeof(this) save();
	//	}
	auto rr = 5.iota;
	writeln("Reference Type Range with .save:");
	auto r3 = refRange(&rr); // manually create a reference range
	r3.save.drop(5).writeln;
	r3.writeln;

	// ForwardRanges can be extended to Bidirectional and RandomAccess Ranges
	//	interface BiderectionalRange(E) : ForwardRange!E
	//	{
	//		E back();
	//		void popBack();
	//	}
	// 	interface RandomAccessRange(E) : ForwardRange!E
	//	{
	//		E opIndex(size_t i);
	//		size_t length();	
	//	}

	writeln("Bidirectional Range:");
	5.iota.retro.writeln;

	// obvious RandomAccessRange is D Array
	writeln("RandomAccess Range:");
	const auto arr = [4, 5, 6];
	arr[1].writeln; // 5

	struct FibonacciRange
	{
		// States of the Fibonacci generator
		int a = 1, b = 1;

		// Fibonacci range never ends
		enum empty = false;

		// peek first element
		int front() const @property
		{
			return a;
		}

		// remove the first element
		void popFront()
		{
			const auto t = a;
			a = b;
			b = t + b;
		}
	}

	FibonacciRange fib;
	import std.algorithm.iteration : filter, sum;
	writeln("Fibonacci Sequence: ");
	auto fib10 = fib.take(10);
	writeln("\tFib 10: ", fib10);

	auto fib5 = fib10.drop(5);
	writeln("\tFib 5: ", fib5);

	auto fibEven = fib5.filter!(x => x % 2 == 0);
	writeln("\tFibEven: ", fibEven);

	writeln("Sum of FibEven: ", fibEven.sum);
}


/// classes are like structs (same as C++), but only classes
/// can use OO concepts like inheritence
void classes()
{
	writeln("\nClasses Basics in D...");

	// all classes inherit from Object implicitly

	class Foo 
	{
		void inheritFunc()
		{
			writeln("Calling inheritFunc from Foo");			
		}

		final void func() 
		{
			writeln("calling func from Foo");
		}

	} // inherits from Object
	class Bar : Foo 
	{
		override void inheritFunc()
		{
			writeln("calling func from Bar which overrides inherited funcion");
		}
	} // Bar is a Foo too

	auto foo = new Foo;
	auto bar = new Bar;

	// classes always reference types
	// unlike structs which are value types

	foo.inheritFunc();
	bar.inheritFunc();
	foo.func();
	bar.func();

	// final
	//		a function can be marked final in a base class
	//		to disallow overrides

	// abstract
	//		a function can be marked as abtract in a base class
	//		to force classes to override it
	//		a whole clas can be declared as abstract to make sure
	//		that it is never instantiated
	
	// super
	//		super(..) can be used explicitly to call
	//	 	the base class constructor

	abstract class Abstract // all functions must inherit
	{
		void func1();
		void func2();

		protected string type;
	} 

	class Inheritor : Abstract
	{
		this(const string type)
		{
			this.type = type;
			printType();
		}

		final override void func1()
		{
			type = "func1 type";
			printType();
		}

		override void func2()
		{
			type = "func2 type";
			printType();
		}

		final void printType()
		{
			writeln("Type in inherited class is: ", type);
		}
	}

	class Inheritor2 : Inheritor
	{
		this(const int n)
		{
			writeln("Calling Inheritor constuctor...");
			super("Inheritor2");
			for(auto i = 0; i < n; ++i)
			{
				func2();
			}
		}

		final override void func2()
		{
			type = "func2 inheritor2 type";
			printType();
		}


	}

	Inheritor inherit = new Inheritor("type");
	inherit.func1();
	inherit.func2();

	Inheritor2 inherit2 = new Inheritor2(2);
	inherit2.func1();
	inherit2.func2();

	Abstract[] abs = [
		new Inheritor("type"),
		new Inheritor2(5)
	];

}

/// interfaces are like classes, but their member funcions must be
/// implemented by any class inheriting from the interface
/// it is a contract that "I satisfy this interface"
void interfaces()
{
	writeln("\nInterface Basics in D...");

	// a function of an interface MUST be implemented
	// by a class inheriting from it
	// so, it essentially acts like an abstract member function
	// in a base class
	// it is a sort of way to ensure different classes
	// implement a common interface, allowing you
	// to call differing classes all together

	interface IAnimal
	{
		void makeNoise();
		final doubleNoise()
		{
			makeNoise();
			makeNoise();
		}

		final multiNoise(const int n)
		{
			for (int i = 0; i < n; ++i)
			{
				makeNoise();
			}
		}
	}

	class Dog : IAnimal
	{
		final void makeNoise()
		{
			writeln("woof");
		}
	}

	class Cat : IAnimal
	{
		void makeNoise()
		{
			writeln("meow");
		}
	}

	class Tiger : Cat
	{
		final override void makeNoise()
		{
			writeln("ROAR");
		}
	}

	// although a class may only directly inherit from one
	// base class, it may implement any number of interfaces

	IAnimal dog = new Dog(); // implicit cast to interface
	dog.makeNoise();
	dog.doubleNoise();

	// non virtual interface (NVI) pattern
	//		NVI pattern allows non-virtual methods
	//		for a common interface.
	//		this patern prevents the violation of a common 
	//		execution pattern

	// this is done in D by allowing final functions
	// to appear in an interface
	// look back at IAnimal to see this

	IAnimal cat = new Cat();
	IAnimal tiger = new Tiger();

	IAnimal[] animals = [
		dog,
		cat, 
		tiger
	];

	foreach (animal; animals)
	{
		animal.multiNoise(2);
	}
	
}

/// templates  are generic functions or objects
/// woo
void templates()
{
	writeln("\nTemplate Basics in D...");
	// THIS is a template
	// 	the tmeplate parameter, T, is defined in the 
	// 	parentheses, denoting that it is a placeholder
	auto add(T)(T lhs, T rhs)
	{
		return lhs + rhs;
	}

	const auto a = add(1,2);
	const auto b = add(2.0f,3.0f);
	const auto c = add(1.0, 2.0);

	// the "!" symbol denotes INSTANTIATION of a template
	// with a specific type,
	// below, "add!int" means "add<int>" in C++
	//	add(5, 10) is valid as well, as the type (int)
	// 	can be deduced by the compiler
	add!int(5, 10);
	add(5, 10);

	// templates can be of anything in D
	struct S(T)
	{
		this(T templateParam )
		{
			this.templatedparam = templateParam;
		}

		private T templatedparam;
		int intparam;

		T getTemplateParam()
		{
			return templatedparam;
		}

		string toString() const
		{
			import std.string : format;
			return format("S:\n\ttemplate param = %d\n\ty = %d", this.templatedparam, this.intparam);
		}
	}

	auto obj = S!int(10);
	const auto get = obj.getTemplateParam();
	writeln(obj);
}


void main()
{
	string s = "Hello World!";
	writeln(s);
	typesBasics();
	memory();
	mutability(s.dup);
	controlFlow();
	functions();
	structs();
	vector3Test();
	arrays();
	aliasAndStrings();
	loops();
	ranges();
	classes();
	interfaces();
	templates();
}
