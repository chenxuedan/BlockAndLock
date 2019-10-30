//
//  CXDView.m
//  TestBlock
//
//  Created by xiao zude on 2019/10/8.
//  Copyright © 2019 zxycloud. All rights reserved.
//

#import "CXDView.h"

@implementation CXDView
- (instancetype)init {
    self = [super init];
    if (self) {
        NSLog(@"hello world!");
    }
    return self;
}


/*
 UIView的setNeedsDisplay和setNeedsLayout方法
 1. 在Mac OS中NSWindow的父类是NSResponder，而在iOS中UIWindow的父类是UIView。程序一般只有一个窗口但是会有很多视图。
2.UIView的作用：描画和动画，视图负责对其所属的矩形区域描画、布局和子视图管理、事件处理、可以接收触摸事件、事件信息的载体等等。
 3. UIViewCotroller负责创建其管理的视图及在低内存的时候将他们从内存中移除。还为标准的系统行为进行响应。
 4.layoutSubViews可以在自己定制的视图中重载这个方法，用来调整子视图的尺寸和位置。
 5.UIView的setNeedsDisplay(需要重新显示，绘制)和setNeedsLayout(需要重新布局)方法。首先两个方法都是异步执行的。而setNeedsDisplay会条用自动调用drawRect方法，这样可以拿到UIGraphicsGetCurrentContext,就可以画画了。而setNeedsLayout会默认调用layoutSubViews，就可以处理子视图中的一些数据。
 综上所述：setNeedsDisplay方便绘图，而layoutSubViews方便出来数据，setNeedsDisplay告知视图它发生了改变，需要重新绘制自身，就相当于刷新界面。
 
 CALayer&UIView
 UIView是iOS系统中界面元素的基础，所有的界面元素都继承自它。它本身完全是由CoreAnimation来实现的(Mac下似乎不是这样)。他真正的绘图部分,是由一个叫CALayer(Core Animation Layer)的类来管理。UIView本身，更像是一个CALayer的管理器，访问他的跟绘图和坐标有关的属性，例如frame，bounds等等，实际上e内部都是在访问它所包含的CALayer的相关的属性。
 UIView有个重要属性layer，可以返回它的主CALayer实例。
 UIView的CALayer类似UIView的子View树形结构，也可以向他的layer上添加子layer,来完成某些特殊的标识。即CALayer层是可以嵌套的。UIView的layer树形在系统内部，被维护者三份copy。分别是逻辑树，这里是代码可以操纵的；动画树，是一个中间层，系统就在这一层上更改树形，进行各种渲染操作；显示数，其内容就是当前正被显示在屏幕上的内容。
 动画的运作：对UIView的subLayer(非主Layer)属性进行更改，系统将自动进行动画生成，动画持续时间的缺省值似乎是0.5秒。
 坐标系统：CALayer的坐标系统比UIView多了一个anchorPoint属性，使用CGPoint结构体标识，值域是0-1，是个比例值。
 渲染：当更新层，改变不能立即显示在屏幕上。当所有的层都准备好是，可以调用setNeedsDisplay方法来重绘显示。
 变换：要在一个层中添加一个3D或仿射变换，可以分别设置层的transform或affine Transform属性，
 变形：Quartz Core的渲染能力，使二维图像可以被自由操纵，就好像是三维的。图像可以在一个三维坐标系中以任意角度被旋转，缩放和倾斜。CATransform3D的一套方法提供了一些魔术般的变换效果。
 
 layoutSubviews&drawRects
 layoutSubviews在以下情况下会被调用(视图位置变化是触发)：
 1. init初始化不会触发layoutSubviews。
 2. addSubView会触发layoutSubviews。
 3. 设置view的frame会触发layoutSubviews,当然前提是frame的值设置前后发生了变化。
 4. 滚动一个UIScrollView会触发layoutSubviews。
 5. 旋转Screen会触发父UIView上的layoutSubviews事件。
 6. 改变一个UIView大小的时候会触发父UIView上的layoutSUbviews事件。
 7. 直接调用setLayoutSubviews。
 
 drawRect在以下情况下会被调用：
 1. 如果在UIView初始化时没有设置rect大小，将直接导致drawRect不被自动调用。drawRect调用是在Controller->loadView, Controller->viewDidLoad两方法之后调用的，所以不用担心在控制器中，这些view的drawRect就开始画了，这样可以在控制器中设置一个值给view(如果这些view draw的时候需要用到某些变量值)
 2. 该方法在调用sizeToFit后被调用，所以可以先调用sizeToFit计算出size。然后系统自动调用drawRect:方法。
 3. 通过设置contentMode属性值为UIViewContentModeRedraw。那么将在每次设置或更改frame的时候自动调用drawRect:。
 4. 直接调用setNeedsDisplay，或者setNeedsDisplayInRect:触发drawRect:,但是有个前提条件是rect不能为0。
 drawRect方法使用注意点：
 1. 若使用UIView绘图，只能在drawRect:方法中获取相应的contextRef并绘图。如果在其他方法中获取将获取到一个invalidate的ref并且不能用于画图。drawRect:方法不能手动显示调用，必须通过调用setNeedsDisplay或者setNeedsDisplayInRect，让系统自动调该方法。
 2.若使用CALayer绘图，只能在drawInContext:中(类似于drawRect)绘制，或者在delegate中的相应方法绘制。同样也是调用setNeedsDisplay等间接调用以上方法
 3. 若要实时画图，不能使用gestureRecognizer，只能使用touchbegan等方法来调用setNeedsDisplay实时刷新屏幕
 
 CPU&GPU
 CPU：中央处理器(英文Central Processing Unit)是一台计算机的运算核心和控制核心。CPU、内部存储器和输入/输出设备是电子计算机三大核心部件。其功能主要是解释计算机指令以及处理计算机软件中的数据。
 GPU：英文全称Graphic Processing Unit，中文翻译为“图形处理器”。一个专门的图形核心处理器。GPU是显示卡的“大脑”，决定了该显卡的档次和大部分性能，同时也是2D显示卡和3D显示卡的区别依据。2D显示芯片在处理3D图像和特效时主要依赖CPU的处理能力，称为“软加速”。3D显示芯片是将三维图像和特效处理功能集中在显示芯片内，也即所谓的“硬件加速”功能。
 
 
 
 
 
 
 **/






@end
