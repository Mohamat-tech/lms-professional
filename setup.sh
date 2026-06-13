#!/bin/bash

# ============================================
# LMS PROFESSIONAL - SETUP SCRIPT
# Développé par NDAOBA MOHAMAT 24G2687
# ============================================

echo "🚀 LMS Professional - Setup Script"
echo "===================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if PHP is installed
if ! command -v php &> /dev/null; then
    echo -e "${RED}❌ PHP is not installed${NC}"
    exit 1
fi

echo -e "${GREEN}✅ PHP found: $(php -v | head -n 1)${NC}"
echo ""

# Check if MySQL is installed
if ! command -v mysql &> /dev/null; then
    echo -e "${YELLOW}⚠️  MySQL not found. You'll need to setup the database manually.${NC}"
else
    echo -e "${GREEN}✅ MySQL found${NC}"
fi

echo ""
echo "📁 Project Structure:"
echo "   ✅ frontend/ - Frontend files (HTML/CSS/JS)"
echo "   ✅ backend/ - Backend API (PHP)"
echo "   ✅ database/ - Database schema (SQL)"
echo "   ✅ tinyhostfiles/ - Files for Tiny.host"
echo ""

echo "📋 Next Steps:"
echo ""
echo "1️⃣  Setup Database:"
echo "   mysql -u root -p < database/schema.sql"
echo ""
echo "2️⃣  Configure Database:"
echo "   Edit: backend/config/database.php"
echo ""
echo "3️⃣  Start Local Server:"
echo "   php -S localhost:8000 -t backend"
echo ""
echo "4️⃣  Access Frontend:"
echo "   http://localhost:3000/frontend"
echo ""
echo "5️⃣  Deploy to GitHub:"
echo "   git init"
echo "   git add ."
echo "   git commit -m 'Initial commit: LMS Professional'"
echo "   git remote add origin https://github.com/YOUR_USERNAME/lms-professional.git"
echo "   git push -u origin main"
echo ""
echo "6️⃣  Deploy to Vercel:"
echo "   vercel deploy"
echo ""
echo "7️⃣  Deploy to Tiny.host:"
echo "   See DEPLOYMENT.md for instructions"
echo ""

echo -e "${GREEN}Setup script complete!${NC}"
echo ""
echo "📚 Documentation:"
echo "   - README.md: Project overview"
echo "   - DEPLOYMENT.md: Deployment guide"
echo "   - database/schema.sql: Database structure"
echo ""

echo "🎉 Happy coding!"
echo ""
echo "Developed by NDAOBA MOHAMAT 24G2687"
