# CMakeLists.txt has to be located in the project folder and cmake has to be
cmake_minimum_required(VERSION 2.8)
project(CommonGUI)

# use this switch to enable compiling as shared application
#SET(BUILD_SHARED_LIBS ON)
# use this switch to enable building of all tests. doing "make test" will execute them.
#enable_testing()

# this allows installing out of project tree with dynamic linkage and relocatable files
# see http://www.cmake.org/Wiki/CMake_RPATH_handling
SET(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

#Set compiler flags
add_definitions("-Wall -ggdb -O3")

set (CMAKE_C_FLAGS "-std=gnu11 ${CMAKE_C_FLAGS}")
set (CMAKE_CXX_FLAGS "-std=gnu++11 ${CMAKE_CXX_FLAGS}")


set(SOURCES_gui
    src/Dummy.cpp
    src/Main.cpp
    )

set(QT_HEADERS_gui # header which should be processed by moc
    src/Dummy.hpp
    )

# set(FORMS_gui
#     src/CommonGUI.ui
#     )
		


add_executable(${PROJECT_NAME}
    ${SOURCES_gui}
    ${HEADERS_gui}
    ${QT_HEADERS_gui}
    ${HEADERS_gui_MOC}
    ${FORMS_gui_HEADERS}
    ${RESOURCES_gui_RCC}
    )
			    

if(${BUILD_SHARED_LIBS})
    target_link_libraries(${PROJECT_NAME} ${${PROJECT_NAME}_PKGCONFIG_LIBRARIES})
else(${BUILD_SHARED_LIBS})
    target_link_libraries(${PROJECT_NAME} ${${PROJECT_NAME}_PKGCONFIG_STATIC_LIBRARIES})
endif(${BUILD_SHARED_LIBS})


# executed from 'project/build' with 'cmake ../'.
#find_package(Rock)
#rock_init(dummy_project 0.1)
#rock_standard_layout()

