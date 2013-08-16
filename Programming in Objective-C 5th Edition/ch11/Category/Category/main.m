//
//  main.m
//  Category
//
//  Created by fenghua on 2013-08-16.
//  Copyright (c) 2013 fenghua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Fraction.h"
#import "Fraction+Mathops.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        Fraction *a =[[Fraction alloc] init];
        Fraction *b = [[Fraction alloc] init];
        Fraction *result;
       
        [a setTo: 1 over: 3];
        [b setTo: 2 over: 5];
        
        [a print]; NSLog (@" +"); [b print]; NSLog (@"-----");
        result = [a add: b];
        [result print];
        NSLog (@"\n");
        [a print]; NSLog (@" -"); [b print]; NSLog (@"-----");
        
        result = [a sub: b];
        [result print];
        
        NSLog (@"\n");
        
        [a print]; NSLog (@" *"); [b print]; NSLog (@"-----");
        
        result = [a mul: b];
        [result print];
        NSLog (@"\n");
        
        [a print]; NSLog (@" /"); [b print]; NSLog (@"-----");
        result = [a div: b];
        [result print];
        NSLog (@"\n");
        
    }
    return 0;
}
/*
 note:
 A cat egory can override anot her met hod in t he class, but t his is considered poor programming practice. For one thing, after you override a method, you can no longer access the original method. Therefore, you must be careful to duplicate all the functionality of the overridden met hod in your replacement . If you do need t o override a met hod, subclassing might be the right choice. If you override a method in a subclass, you can still reference the parent’s method by sending a message to super. So, you don’t have to understand all the intricacies of the method you are overriding; you can just invoke the parent’s method and add your own functionality to the subclass’s method.
 You can have as many categories as you like, following the rules we’ve outlined here. If a met hod is defined in more t han one cat egory, t he language does not specify which one will be used.
 Remember that extending a class by adding new methods with a category affects not just that class, but all its subclasses as well. This can be potentially dangerous if you add new methods to the root object NSObject, for example, because everyone will inherit those new met hods, whet her or not t hat was your int ent ion.
 The new methods you add to an existing class through a category can serve your purposes just fine, but they might be inconsistent with the original design or intentions of the class. Turning a Square int o a Circle (admit t edly, an exaggerat ion), for example, by adding a new category and some methods muddies the definition of the class and is not good programming pract ice.
 Also, object /cat egory named pairs must be unique. Only one NSString category named Utilities can exist in a given Objective-C namespace. This can prove tricky because the Objective-C namespace is shared between the program code and all the libraries, frameworks, and plug-ins. This is especially important for Objective-C programmers writing screensavers, preference panes, and other plug-ins because their code will be injected into application or framework code that they do not control.
 */

/*
 By convention, the base name of the .h and .m files for a category is the class
 name followed by a plus sign, followed by the category name. In our example,
 we would put t he int erface sect ion for t he cat egory in a file named
 Fraction+MathOps.h and t he implement at ion sect ion in a file called Fraction+MathOps.m.
 */

/*
 Categories
 Sometimes you might be working with a class definition and want to add some new methods to it.For example,you might decide for your Fraction class that,in addition to the add: method for adding two fractions,you want to have methods to subtract,multiply,and divide two fractions.
 As another example, suppose that you are working on a large programming project and, as part of that project, your group is defining a new class that contains many different methods. You have been assigned the task of writing methods for the class that work with files. Other project members have been assigned methods responsible for creating and initializing inst ances of t he class, performing operat ions on object s in t he class, and drawing representations of objects from the class on the screen.
 As a final example, suppose you’ve learned how t o use a class from a framework library (for example, the Foundation framework’s array class called NSArray) and realize that you wished that the class had implemented one or more methods. Of course, you could write a new subclass of t he NSArray class and implement t he new met hods, but perhaps an easier way exist s.
 A practical solution for all these situations is categories.A category provides an easy way for you to modularize the definition of a class into groups or categories of related methods. It also gives you an easy way to extend an existing class definition without even having access to the original source code for the class and without having to create a subclass. This is a powerful yet easy concept for you to learn.
*/