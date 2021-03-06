/* ClangPrologPredicates.h ------------------------------------------*- C -*- */

/* Copyright (C) 2011, 2012 Guillem Marpons <gmarpons@babel.ls.fi.upm.es>

   This file is part of Crisp.

   Crisp is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   Crisp is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with Crisp.  If not, see <http://www.gnu.org/licenses/>.
*/

/** \file
 *  \brief External (Clang) predicates to be used from Prolog.
 *
 *  This file contains C++ functions (with ISO-C headers) implementing
 *  Prolog predicates, to be called during Crisp Clang plugin
 *  execution.
 */

#ifndef CRISPCLANGPLUGIN_CLANGPROLOGPREDICATES_H
#define CRISPCLANGPLUGIN_CLANGPROLOGPREDICATES_H

#include <SWI-Prolog.h>

#ifdef __cplusplus
extern "C" {
  namespace crisp {

    namespace prolog {
#endif

      /*  If parameter types are not respected when calling one of the
          following predicates from Prolog, a runtime error is
          raised.

          Every place where a 'Type' argument is used, methods of
          'QualType' can also be used.
      */

      /* Automatically generated function declaration. */

#include "crisp/PrologPredDeclarationMacros.h"
#include "ClangDeclarations.inc"

      /* Manual function declaration. */

      /** \param FunctionProtoTypeT +FunctionProtoType
       */
      foreign_t
      pl_FunctionProtoType_isConstQualified(term_t FunctionProtoTypeT);

      /** \param FunctionT +VarDecl or +FunctionDecl (not a
       *  CXXConstructorDecl or CXXDestructorDecl
       *  \param MangledNameT Atom
       */
      foreign_t pl_mangleName(term_t FunctionT, term_t MangledNameT);

      /** \param DeclT +Decl
       *  \param FilenameT Atom
       *  \param LineT an Integer
       *  \param ColT an Integer
       */
      foreign_t pl_getPresumedLoc(term_t DeclT, term_t FilenameT,
                                  term_t LineT, term_t ColT);

      foreign_t pl_reportViolation(term_t RuleT, term_t MsgT, term_t CulpritsT);

#ifdef __cplusplus
    } /* End namespace crisp::prolog */

  }   /* End namespace crisp  */

} /* End "extern" C */
#endif

#endif  /* #ifndef CRISPCLANGPLUGIN_CLANGPROLOGPREDICATES_H */
